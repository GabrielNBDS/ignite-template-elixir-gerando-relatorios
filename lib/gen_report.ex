defmodule GenReport do
  alias GenReport.Parser

  @people [
    "cleiton",
    "daniele",
    "danilo",
    "diego",
    "giuliano",
    "jakeliny",
    "joseph",
    "mayk",
    "rafael",
    "vinicius"
  ]

  @months %{
    "abril" => 0,
    "agosto" => 0,
    "dezembro" => 0,
    "fevereiro" => 0,
    "janeiro" => 0,
    "julho" => 0,
    "junho" => 0,
    "maio" => 0,
    "março" => 0,
    "novembro" => 0,
    "outubro" => 0,
    "setembro" => 0
  }

  @years %{
    2016 => 0,
    2017 => 0,
    2018 => 0,
    2019 => 0,
    2020 => 0
  }

  def build(file_name) do
    file_name
    |> Parser.parse_file()
    |> Enum.reduce(people_acc(), fn line, people -> add_hours(line, people) end)
  end

  def build() do
    {:error, "Insira o nome de um arquivo"}
  end

  defp people_acc() do
    all_hours = Enum.into(@people, %{}, &{&1, 0})
    hours_per_month = Enum.into(@people, %{}, &{&1, @months})
    hours_per_year = Enum.into(@people, %{}, &{&1, @years})

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp add_hours([name, hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month,
         "hours_per_year" => hours_per_year
       }) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    hours_per_month =
      put_in(
        hours_per_month[name][month],
        hours_per_month[name][month] + hours
      )

    hours_per_year = put_in(hours_per_year[name][year], hours_per_year[name][year] + hours)

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end
end
