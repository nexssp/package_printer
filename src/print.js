const {
  nxsError,
  nxsInfo,
  nxsDebug,
} = require(`${process.env.NEXSS_PACKAGES_PATH}/Nexss/Lib/NexssLog.js`);

const NexssIn = require(`${process.env.NEXSS_PACKAGES_PATH}/Nexss/Lib/NexssIn.js`);
let NexssStdout = NexssIn();

try {
  process.chdir(NexssStdout.cwd);
} catch (error) {
  console.error("ERRRORRRRRR!!!!cwd", NexssStdout.cwd);
  process.exit(1);
}

const availableTypes = [".pdf"];
if (!NexssStdout.nxsIn) {
  nxsError("Add files to be printed: " + availableTypes.join(", "));
  console.error(NexssStdout);
  process.exit(1);
}

const cp = require("child_process");
const path = require("path");
const fs = require("fs");
let result = [];
let errors = [];
let printerName = "Microsoft Print to PDF";
if (NexssStdout.printerName) {
  printerName = NexssStdout.printerName;
}

// Check if documents for printing exists
let doesNotExists = [];
NexssStdout.nxsIn.forEach((element) => {
  if (!fs.existsSync(element)) {
    doesNotExists.push(element);
  }
});

if (doesNotExists.length > 0) {
  nxsError("Nothing will be printed as can't find document(s):");
  nxsError(doesNotExists);
  process.exit(1);
}

// All documents exists, printing
NexssStdout.nxsIn.forEach((element) => {
  const extension = path.extname(element);

  if (!availableTypes.includes(extension)) {
    nxsError(
      "Printer prints these file types: " +
        availableTypes.join(", ") +
        ". You passed: " +
        element
    );
    process.exit(1);
  }

  const command =
    'gswin64c -q -sDEVICE=mswinpr2 -dBATCH -dNOPAUSE -dFitPage -sOutputFile="%printer%' +
    printerName +
    '"';

  switch (extension) {
    case ".pdf":
      try {
        nxsInfo(`Printing ${element}`);
        nxsDebug(`Execute '${command}'`);
        const res = cp.execSync(`${command} "${element}"`).toString();
        if (res) console.log(res);
        result.push(element);
      } catch (error) {
        errors.push(error.message);
        nxsError(error.message);
      }
      break;
    // case ".txt":
    //   break;
    default:
      nxsError(
        `Extension ${extension} is not yet recognized by nexss Convert/ToTxt`
      );
      break;
  }
});
NexssStdout.nxsOut = result;
if (errors.length > 0) NexssStdout.nxsOut_2 = errors;
delete NexssStdout.nxsIn;
delete NexssStdout.resultField_1;

process.stdout.write(JSON.stringify(NexssStdout));
