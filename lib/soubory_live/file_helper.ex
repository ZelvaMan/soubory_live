defmodule SouboryLive.FileHelper do
  alias SouboryLive.Models.SimpleFile
  alias SouboryLive.Models.FileInfo

  require Logger

  # converts path to SimpleFile struct
  def path_to_SimpleFile(path) do
    info_tuple = File.stat(path)
    file = %SimpleFile{name: Path.basename(path)}

    file =
      if elem(info_tuple, 0) === :ok do
        # we were able to get file info
        info = elem(info_tuple, 1)

        %{
          file
          | size:
              if info.type == :regular do
                info.size
              else
                0
              end,
            extension: Path.extname(path),
            type: info.type,
            fullpath:
              if info.type == :directory do
                path <> "/"
              else
                path
              end
        }
      else
        file
      end

    file
  end

  # return infos about files in curent directory
  def get_infos(path) do
    Enum.map(File.ls!(path), fn x ->
      path_to_SimpleFile(path <> x)
    end)
  end

  # return parent directory of path
  def get_parent(path) do
    String.replace(String.replace(path, Path.basename(path) <> "/", ""), Path.basename(path), "")
  end

  def get_file_info(path) do
    info_tuple = File.stat(path)

    if elem(info_tuple, 0) === :ok do
      info = elem(info_tuple, 1)

      %FileInfo{
        name: Path.basename(path),
        size: info.size,
        extension: Path.extname(path),
        fullpath: path,
        access: info.access
      }
    else
    end
  end

  # orders SimpleFiles
  def order_infos(files, order) do
    case order do
      :type_dec ->
        # default sort
        Enum.sort(files, fn x, _y ->
          if x.type === :directory do
            true
          else
            false
          end
        end)

      :type_inc ->
        Enum.sort(files, fn x, _y ->
          if x.type === :directory do
            false
          else
            true
          end
        end)

      # by alphabet
      :name_dec ->
        Enum.sort(files, fn x, y ->
          if String.downcase(x.name) > String.downcase(y.name) do
            false
          else
            true
          end
        end)

      :name_inc ->
        Enum.sort(files, fn x, y ->
          if String.downcase(x.name) < String.downcase(y.name) do
            false
          else
            true
          end
        end)

      :size_dec ->
        Enum.sort(files, fn x, y ->
          if x.size < y.size do
            false
          else
            true
          end
        end)

      :size_inc ->
        Enum.sort(files, fn x, y ->
          if x.size > y.size do
            false
          else
            true
          end
        end)

      _ ->
        files
    end
  end

  def search_files(path, search_query) do
    Enum.map(
      Enum.filter(File.ls!(path), fn x ->
        String.contains?(x, search_query)
      end),
      fn x ->
        path_to_SimpleFile(path <> x)
      end
    )
  end

  def make_path_valid(path) do
    allowed_path = allowed_path()

    case String.contains?(path, allowed_path) do
      true -> path
      _ -> allowed_path
    end
  end

  def allowed_path() do
    # Application.get_env(:soubory, SouboryLiveWeb.Endpoint)[:path]
    "C:/TEST/"
  end
end
