defmodule SouboryLive.ZipManager do
  alias SouboryLive.FileHelper

  def create_zip(source_pid, selected) do
    DynamicSupervisor.start_child(
      SouboryLive.ZipDynamicSupervisor,
      {SouboryLive.ZipWorker, [source_pid, selected]}
    )
  end
end
