'use strict'
const fs = require('fs');
const fs_promises = require('fs').promises;
const http = require('https');
const server = http.createServer();
server.listen(3002); // just to make the process does not exit.
const axios = require('axios').default;
const BASE_URL = process.env.BASE_URL;
const PAGE_ID_LIST = process.env.PAGES?.split(','); // expected to be comma separated page ids.
async function processPageIdList() {
  const options = {
    auth: {
      username: process.env.CONFLUENCE_USER_NAME,
      password: process.env.CONFLUENCE_TOKEN
    }
  };
  for (const page_id of PAGE_ID_LIST) {
    try {
      const response = await axios.get(`${BASE_URL}/rest/api/content/${page_id}?expand=body.storage`, options);
      const folderPath = `../pages/${response.data.title.replaceAll(' ','_')}`;
      const filePath = `${folderPath}/data.json`;
      if (fs.existsSync(filePath)) {
        const fileData = await fs_promises.readFile(filePath,'utf-8');
        if (fileData !== JSON.stringify(response.data)) {
          await fs_promises.writeFile(filePath, response?.data);
          await fs_promises.writeFile(folderPath + '/README.md', response?.data?.body?.storage?.value);
        }else{
          console.info('It is already the latest version', page_id);
        }
      } else {
        fs.mkdirSync(folderPath, { recursive: true });
        await fs_promises.writeFile(filePath, JSON.stringify(response?.data));
        await fs_promises.writeFile(folderPath + '/README.md', response?.data?.body?.storage?.value);
      }
    } catch (err) {
      console.error(err);
    }
  }
}

processPageIdList().then(() => {
  console.info('process completed.');
  process.exit(0);
}).catch(err => {
  console.error(err);
  process.exit(1);
});

