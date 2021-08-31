defmodule SouboryLive.ZipWorker do
  use Task
  alias SouboryLive.FileHelper
  require Logger

  def start_link([finish_callback, selected]) do
    files = selected |> Enum.map(&String.to_charlist/1)
    path = FileHelper.generate_zip_path()
    {status, _} = :zip.create(path, files)

    case status do
      :ok ->
        Logger.info("zip created name: #{Path.basename(path)}")

        finish_callback.(path)

      _ ->
        :error
    end
  end
end
