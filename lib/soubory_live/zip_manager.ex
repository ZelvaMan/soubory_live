defmodule SouboryLive.ZipManager do
  alias SouboryLive.FileHelper

  def create_zip(socket, selected) do
    DynamicSupervisor.start_child(
      SouboryLive.ZipDynamicSupervisor,
      {SouboryLive.ZipWorker, [socket, selected]}
    )
  end
end
