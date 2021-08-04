defmodule SouboryLiveWeb.FileLive do
  use SouboryLiveWeb, :live_view
  alias SouboryLive.FileHelper

  def mount(%{"path" => path}, _session, socket) do
    parent =
      path
      |> FileHelper.get_parent()
      |> FileHelper.make_path_valid()

    {:ok,
     assign(socket,
       parent: parent,
       info: FileHelper.get_file_info(path)
     )}
  end
end
