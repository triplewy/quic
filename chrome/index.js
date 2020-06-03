/* eslint-disable indent */
/* eslint-disable no-restricted-syntax */
/* eslint-disable no-await-in-loop */
const puppeteer = require('puppeteer-core');
const PuppeteerHar = require('puppeteer-har');
const lighthouse = require('lighthouse');
const chromeLauncher = require('chrome-launcher');
const path = require('path');
const fs = require('fs');

const chromeArgs = (port, isQuic) => {
    const args = [
        '--user-data-dir=/tmp/chrome-profile',
        '--enable-quic',
        '--quic-version=h3-27',
        '--allow-insecure-localhost',
        '--disk-cache-dir=/dev/null',
        '--disk-cache-size=1',
        `--host-resolver-rules=MAP www.example.org:443 127.0.0.1:${port}`,
    ];

    if (isQuic) {
        args.push(
            '--origin-to-force-quic-on=www.example.org:443',
        );
    }

    return args;
};


const query = async (name, args, objectSize, numObjects) => {
    const browser = await puppeteer.launch({
        headless: false,
        executablePath: '/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary',
        args,
    });

    const harDir = path.join('har', objectSize, name);
    fs.mkdirSync(harDir, { recursive: true });

    const page = await browser.newPage();
    const har = new PuppeteerHar(page);

    const harPath = path.join(harDir, `index-${numObjects}.har`);

    console.log(`Executing scenario: ${objectSize}-${numObjects}`);

    await har.start({ path: harPath });
    try {
        await page.goto(`https://www.example.org/${objectSize}/index-${numObjects}.html`, {
            timeout: 60000,
        });
    } catch (error) {
        console.error(error);
    }

    await har.stop();
    await page.close();
    await browser.close();
};

const launchChromeAndRunLighthouse = (url, chromeFlags, config = null) => {
    // Set path of chrome executable
    process.env.CHROME_PATH = '/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary';


    chromeLauncher.launch({ chromeFlags }).then((chrome) => {
        const opts = {
            port: chrome.port,
            onlyCategories: ['performance'],
            chromeFlags,
        };

        return lighthouse(url, opts, config).then((results) => {
            // use results.lhr for the JS-consumable output
            // https://github.com/GoogleChrome/lighthouse/blob/master/types/lhr.d.ts
            // use results.report for the HTML/JSON/CSV output as a string
            // use results.artifacts for the trace/screenshots/other specific case you need (rarer)
            chrome.kill().then(() => {
                // console.log(results.report);
                console.log(typeof results.report);

                fs.writeFileSync(path.join('lighthouse', 'index.html'), results.report);
                // console.log(results.lhr);
            });
        });
    });
};

const [, , serverName, port, objectSize, numObjects] = process.argv;

(async () => {
    const isQuic = (() => {
        switch (serverName) {
            case 'http2':
                return false;
            case 'proxygen':
                return true;
            case 'quiche':
                return true;
            case 'chromium':
                return true;
            default:
                throw Error;
        }
    })();

    console.log(`Running benchmarks for { Name: ${serverName}, Object Size: ${objectSize}, Num Objects: ${numObjects} }`);

    const args = chromeArgs(port, isQuic);
    // launchChromeAndRunLighthouse(`https://www.example.org/${objectSize}/index-${numObjects}.html`, args);
    await query(serverName, args, objectSize, numObjects);
})();
