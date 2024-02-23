let
    Query2 = {2..150},
    #"Converted to Table" = Table.FromList(Query2, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Changed Type" = Table.TransformColumnTypes(#"Converted to Table",{{"Column1", type text}}),
    #"Added Custom" = Table.AddColumn(#"Changed Type", "Requisição", each "div:nth-child("&[Column1]&")"),
    #"Added Custom1" = Table.AddColumn(#"Added Custom", "Custom", each Html.Table((Web.BrowserContents("https://www.sescbahia.com.br/LicitacaoView.aspx?tipo=aberto")), 
                                                {{"Column1", "#ctl00_ContentPlaceHolder1_upGeral >" &[Requisição]& "> div.tituloLicitacao"},
                                                {"Column2", "#ctl00_ContentPlaceHolder1_upGeral >" &[Requisição]& "> div:nth-child(2)"},
                                                {"Column3", "#ctl00_ContentPlaceHolder1_upGeral >" &[Requisição]& "> div:nth-child(3)"},
                                                {"Column4", "#ctl00_ContentPlaceHolder1_upGeral >" &[Requisição]& "> div:nth-child(4)"},
                                                {"Column5", "#ctl00_ContentPlaceHolder1_upGeral >" &[Requisição]& "> div:nth-child(5)"},
                                                {"Column6", "#ctl00_ContentPlaceHolder1_upGeral >" &[Requisição]& "> div:nth-child(6)"}},
                                                [RowSelector= "#ctl00_ContentPlaceHolder1_upGeral > div:nth-child(2)"])),
    #"Expanded Custom" = Table.ExpandTableColumn(#"Added Custom1", "Custom", {"Column1", "Column2", "Column3", "Column4", "Column5", "Column6"}, {"Column1.1", "Column2", "Column3", "Column4", "Column5", "Column6"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded Custom",{"Column1", "Requisição"}),
    #"Extracted Text After Delimiter" = Table.TransformColumns(#"Removed Columns", {{"Column2", each Text.AfterDelimiter(_, ":"), type text}, {"Column3", each Text.AfterDelimiter(_, ":"), type text}, {"Column4", each Text.AfterDelimiter(_, ":"), type text}, {"Column5", each Text.AfterDelimiter(_, ":"), type text}, {"Column6", each Text.AfterDelimiter(_, ":"), type text}}),
    #"Inserted Text After Delimiter" = Table.AddColumn(#"Extracted Text After Delimiter", "Abertura", each Text.AfterDelimiter([Column2], ":"), type text),
    #"Extracted Text Before Delimiter" = Table.TransformColumns(#"Inserted Text After Delimiter", {{"Column2", each Text.BeforeDelimiter(_, "A"), type text}}),
    #"Trimmed Text" = Table.TransformColumns(#"Extracted Text Before Delimiter",{{"Column2", Text.Trim, type text}, {"Column3", Text.Trim, type text}, {"Column4", Text.Trim, type text}, {"Column5", Text.Trim, type text}, {"Column6", Text.Trim, type text}}),
    #"Renamed Columns" = Table.RenameColumns(#"Trimmed Text",{{"Column2", "Edital"},{"Column3", "Modalidade"},{"Column4", "Titulo"},{"Column5", "Objeto"},{"Column6", "Arquivos"}}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Renamed Columns",{{"Abertura", type date}})
in
    #"Changed Type1"