/* eslint-disable no-restricted-syntax */
/* eslint-disable no-await-in-loop */
const puppeteer = require('puppeteer-core');
const PuppeteerHar = require('puppeteer-har');
const path = require('path');
const fs = require('fs');

const query = async (name, port, isQuic) => {
    const args = [
        '--user-data-dir=/tmp/chrome-profile',
        '--enable-quic',
        '--quic-version=h3-27',
        '--allow-insecure-localhost',
        '--disk-cache-dir=/dev/null',
        '--disk-cache-size=1',
    ];

    if (isQuic) {
        args.push(`--origin-to-force-quic-on=127.0.0.1:${port}`);
    }

    const browser = await puppeteer.launch({
        headless: false,
        executablePath: '/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary',
        args,
    });

    const sizes = ['10kb', '100kb', '1000kb'];
    const nums = ['1', '10', '100'];

    // eslint-disable-next-line no-restricted-syntax
    for (const size of sizes) {
        const harDir = path.join('har', name, size);
        fs.mkdirSync(harDir, { recursive: true });
        for (const num of nums) {
            const page = await browser.newPage();
            const har = new PuppeteerHar(page);

            const harPath = path.join(harDir, `index-${num}.har`);

            console.log(`Executing scenario: ${size}-${num}`);

            await har.start({ path: harPath });
            await page.goto(`https://127.0.0.1:${port}/${size}/index-${num}.html`);

            await har.stop();
            await page.close();
        }
    }

    await browser.close();
};

(async () => {
    const versions = [
        { name: 'httpd', port: '30000', isQuic: false },
        { name: 'proxygen', port: '30001', isQuic: true },
        { name: 'quiche', port: '30002', isQuic: true },
    ];

    for (const { name, port, isQuic } of versions) {
        console.log(`Running benchmarks for ${name}`);
        await query(name, port, isQuic);
    }
})();
