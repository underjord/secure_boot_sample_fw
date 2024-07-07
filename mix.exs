defmodule SecFw.MixProject do
  use Mix.Project

  @app :sec_fw
  @version "0.1.0"
  @all_targets [
    :rpi,
    :rpi0,
    :rpi2,
    :rpi3,
    :rpi3a,
    :rpi4,
    :secure_cm4,
    :bbb,
    :osd32mp1,
    :x86_64,
    :grisp2,
    :mangopi_mq_pro
  ]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.11",
      archives: [nerves_bootstrap: "~> 1.12"],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {SecFw.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.10", runtime: false},
      {:shoehorn, "~> 0.9.1"},
      {:ring_logger, "~> 0.10.0"},
      {:toolshed, "~> 0.3.0"},

      # Allow Nerves.Runtime on host to support development, testing and CI.
      # See config/host.exs for usage.
      {:nerves_runtime, "~> 0.13.0"},

      # Dependencies for all targets except :host
      {:nerves_pack, "~> 0.7.0", targets: @all_targets},

      # Dependencies for specific targets
      # NOTE: It's generally low risk and recommended to follow minor version
      # bumps to Nerves systems. Since these include Linux kernel and Erlang
      # version updates, please review their release notes in case
      # changes to your application are needed.
      #{:nerves_system_rpi4, "> 0.0.0", runtime: false, targets: :rpi4},
      #{:nerves_system_rpi4, github: "nerves-project/nerves_system_rpi4", runtime: false, targets: :rpi4},
      #{:secure_boot_rpi4, path: "../secure_boot_rpi4", runtime: false, targets: :rpi4, nerves: [compile: true]},
      {:secure_outer_rpi4, path: "../secure_outer_rpi4", runtime: false, targets: :secure_cm4, nerves: [compile: true]},

      {:vintage_net, github: "underjord/vintage_net", override: true},
      {:vintage_net_wifi, github: "underjord/vintage_net_wifi", branch: "supplicant", override: true},
      {:vintage_net_ethernet, github: "underjord/vintage_net_ethernet", branch: "supplicant", override: true},
      {:vintage_net_supplicant, github: "underjord/vintage_net_supplicant", override: true},

      {:nerves_key, "~> 1.2"}
    ]
  end

  def release do
    [
      overwrite: true,
      # Erlang distribution is not started automatically.
      # See https://hexdocs.pm/nerves_pack/readme.html#erlang-distribution
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]]
    ]
  end
end
