const vscode = require("vscode");
const { exec } = require("child_process");
const path = require("path");

function backupExtensions() {
  const scriptPath = path.join(
    __dirname,
    "../scripts/update-vscode-extensions.sh"
  );
  console.log("Dotfiles Sync: Backing up VS Code extensions...");

  vscode.window.withProgress(
    {
      location: vscode.ProgressLocation.Notification,
      title: "Dotfiles Sync: Backing up extensions...",
      cancellable: false,
    },
    async (progress) => {
      return new Promise((resolve, reject) => {
        exec(scriptPath, (error, stdout, stderr) => {
          if (error) {
            console.error(`Dotfiles Sync error: ${error.message}`);
            vscode.window.showErrorMessage(
              `Dotfiles Sync: Backup failed - ${error.message}`
            );
            reject(error);
            return;
          }
          if (stderr) {
            console.error(`Dotfiles Sync stderr: ${stderr}`);
            vscode.window.showErrorMessage(
              `Dotfiles Sync: Backup failed - ${stderr}`
            );
            reject(new Error(stderr));
            return;
          }
          console.log(`Dotfiles Sync: ${stdout}`);
          vscode.window.showInformationMessage(
            `Dotfiles Sync: Extensions backed up ✓ - ${stdout.trim()}`
          );

          setTimeout(() => resolve(), 1000);
        });
      });
    }
  );
}

/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {
  console.log("Dotfiles Sync extension is now active");

  // Listen for extension changes (install/uninstall)
  const disposable = vscode.extensions.onDidChange(() => {
    console.log("Dotfiles Sync: Extension change detected");
    backupExtensions();
  });

  context.subscriptions.push(disposable);
}

function deactivate() {
  // Backup on shutdown as well
  backupExtensions();
}

module.exports = {
  activate,
  deactivate,
};
