import fs from "fs";

const unLink = fs.unlink;

/**
 *
 * @param {string[]} filesUri
 * @param {boolean} continueWhenError
 * @returns
 */
const deleteFiles = (filesUri, continueWhenError = false) => {
  return new Promise(() => {
    filesUri.forEach((uri) => {
      unLink(uri, (error) => {
        if (error) {
          if (!continueWhenError) {
            throw error;
          } else {
            console.log(`Delete file ${uri} fail, continue`);
          }
        } else console.log("The file with Uri " + uri + "is deleted");
      });
    });
    console.log("All file is deleted, number: " + filesUri.length);
  });
};

export { deleteFiles };
