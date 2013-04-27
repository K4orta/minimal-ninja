-- Display the settings for the exporter.

DAME.AddHtmlTextLabel("Ensure you use the <b>ComplexClaws</b> PlayState.as file in the samples as the template for any code.")
DAME.AddBrowsePath("AS3 dir:","AS3Dir",false, "Where you place the Actionscript files.")
DAME.AddBrowsePath("CSV dir:","CSVDir",false)

versions = as3.class.Array.new()
DAME.AddCheckbox("Export only CSV","ExportOnlyCSV",false,"If ticked then the script will only export the map CSV files and nothing else.")

return 1
