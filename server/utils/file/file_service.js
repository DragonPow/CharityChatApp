import fs from "fs";

const unLink = fs.unlink;

const deleteFiles = (filesUri) => {
  return new Promise(() => {
    filesUri.forEach((uri) => {
      unLink(uri, (error) => {
        if (error) throw error;
        console.log("The file with Uri " + uri + "is deleted");
      });
    });
    console.log("All file is deleted, number: " + filesUri.length);
  });
};

export { deleteFiles };
