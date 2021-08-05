defmodule SouboryLiveWeb.FilesLive do
  use SouboryLiveWeb, :live_view
  alias SouboryLive.FileHelper

  def mount(params, _session, socket) do
    path = FileHelper.make_path_valid(params["path"] || FileHelper.allowed_path())

    {:ok,
     assign(socket,
       path: path,
       files: FileHelper.get_infos(path),
       sq: "",
       order: nil,
       # list of fullpaths of selected files and folders
       selected: [],
       all_selected: false
     )}
  end

  def handle_event("search", %{"search_query" => sq}, socket) do
    {:noreply, assign(socket, files: FileHelper.search_files(socket.assigns.path, sq), sq: sq)}
  end

  def handle_event("change_path", %{"new_path" => new_path}, socket) do
    path =
      new_path
      |> FileHelper.make_path_valid()

    # {:noreply, assign(socket, files: FileHelper.get_infos(path), sq: "", path: path)}
    {:noreply,
     push_patch(assign(socket, selected: [], all_selected: false),
       to: Routes.files_path(socket, :files, path)
     )}
  end

  def handle_event("go_up", _, socket) do
    path =
      socket.assigns.path
      |> FileHelper.get_parent()
      |> FileHelper.make_path_valid()

    # {:noreply, assign(socket, files: FileHelper.get_infos(path), sq: "", path: path)}
    {:noreply,
     push_patch(assign(socket, selected: [], all_selected: false),
       to: Routes.files_path(socket, :files, path)
     )}
  end

  def handle_params(params, _uri, socket) do
    path = FileHelper.make_path_valid(params["path"] || FileHelper.allowed_path())

    {:noreply,
     assign(socket,
       path: path,
       files: FileHelper.get_infos(path),
       sq: ""
     )}
  end

  def handle_event("type_sort", _, socket) do
    order =
      case socket.assigns.order do
        :type_dec -> :type_inc
        :type_inc -> :type_dec
        _ -> :type_dec
      end

    {:noreply,
     assign(socket, files: FileHelper.order_infos(socket.assigns.files, order), order: order)}
  end

  def handle_event("name_sort", _, socket) do
    order =
      case socket.assigns.order do
        :name_dec -> :name_inc
        :name_inc -> :name_dec
        _ -> :name_dec
      end

    {:noreply,
     assign(socket, files: FileHelper.order_infos(socket.assigns.files, order), order: order)}
  end

  def handle_event("select_all", _, socket) do
    case socket.assigns.selected do
      [] ->
        {:noreply,
         assign(socket,
           all_selected: true,
           selected: FileHelper.get_all_directories(socket.assigns.path)
         )}

      _ ->
        {:noreply, assign(socket, all_selected: false, selected: [])}
    end
  end

  def handle_event("select", %{"fullpath" => fullpath}, socket) do
    old_selected = socket.assigns.selected

    new_selected =
      case Enum.member?(old_selected, fullpath) do
        true ->
          List.delete(old_selected, fullpath)

        false ->
          old_selected ++ [fullpath]
      end

    {:noreply, assign(socket, selected: new_selected)}
  end

  def handle_event("create_zip", _, socket) do
  end
end
