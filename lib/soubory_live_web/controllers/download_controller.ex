defmodule SouboryLiveWeb.DownloadController do
  use SouboryLiveWeb, :controller

  def zip(conn, params) do
    path = params["path"]

    if path == nil || !File.exists?(path) ||
         !String.contains?(path, SouboryLive.FileHelper.zip_folder_path()) do
      send_resp(conn, 404, " ERROR:\n file does not exist or you cant have it :D")
    else
      send_download(conn, {:file, path})
    end
  end
end
