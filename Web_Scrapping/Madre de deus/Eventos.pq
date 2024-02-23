let
    listaGerada = List.Generate(
    () => [x = 1, y = {}],
    each [x] <= 4455,
    each [x = [x] + 5, y = [y] & {[x]}], 
    each [x] 
),
    #"Converted to Table" = Table.FromList(listaGerada, Splitter.SplitByNothing(), null, "Eventos", ExtraValues.Error),
    #"Renamed Columns" = Table.RenameColumns(#"Converted to Table",{{"Column1", "Eventos"}}),
    #"Added Index" = Table.AddIndexColumn(#"Renamed Columns", "Index", 1, 1, Int64.Type),
    #"Merged Queries" = Table.NestedJoin(#"Added Index", {"Index"}, #"Pages (2)", {"Index"}, "Pages (2)", JoinKind.LeftOuter),
    #"Expanded Pages (2)" = Table.ExpandTableColumn(#"Merged Queries", "Pages (2)", {"Column1"}, {"Column1"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Expanded Pages (2)",{{"Index", "Page_Fact"}, {"Column1", "Pages_Attribute"}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Renamed Columns1",{{"Eventos", type text}, {"Page_Fact", type text}, {"Pages_Attribute", type text}}),
    #"Added Custom" = Table.AddColumn(#"Changed Type", "Custom", each "http://ba.portaldatransparencia.com.br/prefeitura/madrededeus/?pagina=dop&frompage="&[Eventos]&"&StartRow="&[Pages_Attribute])
in
    #"Added Custom"