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
       order: nil
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
    {:noreply, push_patch(socket, to: Routes.files_path(socket, :files, path))}
  end

  def handle_event("go_up", _, socket) do
    path =
      socket.assigns.path
      |> FileHelper.get_parent()
      |> FileHelper.make_path_valid()

    # {:noreply, assign(socket, files: FileHelper.get_infos(path), sq: "", path: path)}
    {:noreply, push_patch(socket, to: Routes.files_path(socket, :files, path))}
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
end
