defmodule SouboryLiveWeb.DownloadController do
  use SouboryLiveWeb, :controller

  def zip(conn, params) do
    path = params["path"]

    if path == nil do
      {:error, :path_not_valid}
    else
      send_download(conn, {:file, path})
    end
  end
end
