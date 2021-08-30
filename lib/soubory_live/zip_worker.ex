defmodule SouboryLive.ZipWorker do
  use Task
  alias SouboryLive.FileHelper
  require Logger

  def start_link([socket, selected]) do
    files = selected |> Enum.map(&String.to_charlist/1)
    path = FileHelper.generate_zip_path()
    {status, _} = :zip.create(path, files)

    case status do
      :ok ->
        Logger.info("zip created schould push show_path")

        Logger.info(
          Phoenix.LiveView.push_event(socket, "show_path", %{file_name: Path.basename(path)})
        )

      _ ->
        :error
    end
  end
end
