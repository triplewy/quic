/* eslint-disable indent */
/* eslint-disable no-restricted-syntax */
/* eslint-disable no-await-in-loop */
const puppeteer = require('puppeteer-core');
const PuppeteerHar = require('puppeteer-har');
const path = require('path');
const fs = require('fs');

const query = async (name, port, isQuic, objectSize, numObjects) => {
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

    await query(serverName, port, isQuic, objectSize, numObjects);
})();
