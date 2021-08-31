defmodule SouboryLive.ZipManager do
  alias SouboryLive.FileHelper

  def create_zip(callback, selected) do
    DynamicSupervisor.start_child(
      SouboryLive.ZipDynamicSupervisor,
      {SouboryLive.ZipWorker, [callback, selected]}
    )
  end
end
