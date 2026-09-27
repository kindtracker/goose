const LuaPackagesPath = "/usr/local/share/lua/5.5/";
const PackagesToInstallTree = `lunar/vendors/url.lua
`;

async function GetContent(Url, Text) {
  const Response = await fetch(Url);
  if (!Response.ok) throw new Error(`Failed to fetch ${Url}: ${Response.status}`);
  return Text ? await Response.text() : await Response.json();
}

window.addEventListener("GooseLuaLoaded", () => {
});

window.Module = {
  onRuntimeInitialized: async () => {
    const Config = await GetContent("/project/config.json");
    for (const FilePath of Config.Files) {
      const FileContent = await GetContent("/project/" + FilePath, true);
      FS.writeFile("/" + FilePath, FileContent);
    }

    FS.mkdirTree("/gooselib");
    for (const [FilePath, FileContent] of Object.entries(window.GoosePackages)) {
      const Directory = FilePath.substring(0, FilePath.lastIndexOf("/"));
      if (Directory) {
        FS.mkdirTree(Directory);
      }
      FS.writeFile(FilePath, FileContent);
    }

    console.log("[Goose] Initialized");
    Module._Main();
  }
};
