defmodule SouboryLive.ZipWorker do
  def start_link([source_pid, selected]) do
    files = selected |> Enum.map(&String.to_charlist/1)
    path = FileHelper.generate_zip_path()
    :zip.create(path, files)
  end
end
