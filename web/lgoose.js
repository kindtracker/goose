async function GetContent(Url, Text) {
  const Response = await fetch(Url);
  if (!Response.ok) throw new Error(`Failed to fetch ${Url}: ${Response.status}`);
  return Text ? await Response.text() : await Response.json();
}

window.Module = {
  onRuntimeInitialized: async () => {
    console.log("test");
    const Config = await GetContent("/project/config.json");
    for (const FilePath of Config.Files) {
      const FileContent = await GetContent("/project/" + FilePath, true);
      FS.writeFile("/" + FilePath, FileContent);
    }
    console.log("[Goose] Initialized");
    Module._Main();
  }
};
