const LuaPackagesPath = "/usr/local/share/lua/5.5/";
const PackagesToInstallTree = `lunar/vendors/url.lua
lunar/vendors/json.lua
lunar/vendors/pegasus/compress.lua
lunar/vendors/pegasus/log.lua
lunar/vendors/pegasus/response.lua
lunar/vendors/pegasus/handler.lua
lunar/vendors/pegasus/plugins/router.lua
lunar/vendors/pegasus/plugins/compress.lua
lunar/vendors/pegasus/plugins/downloads.lua
lunar/vendors/pegasus/plugins/files.lua
lunar/vendors/pegasus/plugins/tls.lua
lunar/vendors/pegasus/request.lua
lunar/vendors/pegasus/init.lua
lunar/init.lua
lunar/src/datatypes/color3.lua
lunar/src/datatypes/color4.lua
lunar/src/datatypes/udim2.lua
lunar/src/datatypes/cframe.lua
lunar/src/datatypes/udim.lua
lunar/src/datatypes/vector3.lua
lunar/src/datatypes/connection.lua
lunar/src/datatypes/signal.lua
lunar/src/datatypes/vector2.lua
lunar/src/services/http-server.lua
lunar/src/services/task.lua
lunar/src/services/fs.lua
lunar/src/services/http-client.lua
lunar/src/services/time.lua
lunar/src/services/run.lua
lunar/src/services/console.lua
lunar/src/services/error.lua
lunar/src/services/libraries/lstring.lua
lunar/src/services/libraries/ltable.lua
lunar/src/services/libraries/lmath.lua
lunar/src/services/json.lua
lunar/src/services/plugin.lua
lunar/src/services/http-shared.lua
lunar/src/services/random.lua
lunar/src/core/service.lua
lunar/src/core/instance.lua
lunar/src/init.lua
luamimetypes/mimetypes.lua
luamimetypes/mimetypes/extensions.lua
luamimetypes/mimetypes/filenames.lua
luamimetypes/mimetypes/generated.lua
luasocket/url.lua
luasocket/smtp.lua
luasocket/ftp.lua
luasocket/http.lua
luasocket/mbox.lua
luasocket/tftp.lua
luasocket/tp.lua
luasocket/headers.lua
uluasocket/ltn12.lua
uluasocket/socket.lua
uluasocket/mime.lua
gooselib/goose.lua
gooselib/page.lua`;

async function GetContent(Url, Text) {
  const Response = await fetch(Url);
  if (!Response.ok) throw new Error(`Failed to fetch ${Url}: ${Response.status}`);
  return Text ? await Response.text() : await Response.json();
}

window.Module = {
  onRuntimeInitialized: async () => {
    const Config = await GetContent("/project/config.json");
    for (const FilePath of Config.Files) {
      const FileContent = await GetContent("/project/" + FilePath, true);
      FS.writeFile("/" + FilePath, FileContent);
    }


    FS.mkdirTree("/gooselib");
    for (const FilePath of PackagesToInstallTree.split("\n")) {
      const WebFilePath = FilePath.replace("uluasocket", "luasocket");
      const InstallFilePath = FilePath.replace("luasocket", "socket")
        .replace("usocket/", "")
        .replace("luamimetypes/", "");
      console.log("[Goose] Loading:", WebFilePath);

      const Directory = InstallFilePath.substring(0, InstallFilePath.lastIndexOf("/"));
      if (Directory) {
        FS.mkdirTree(LuaPackagesPath + Directory);
      }
 
      const IsGooseLib = WebFilePath.includes("gooselib");
      const FileContent = await GetContent((IsGooseLib ? "/goosel/" :  "/goosel/vendors/") + WebFilePath, true);
      console.log(IsGooseLib ? "/" + InstallFilePath : LuaPackagesPath + InstallFilePath)
      FS.writeFile(IsGooseLib ? "/" + InstallFilePath : LuaPackagesPath + InstallFilePath, FileContent);
    }

    console.log("[Goose] Initialized");
    Module._Main();
  }
};
