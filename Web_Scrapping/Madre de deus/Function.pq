(URL)=> // função para realizar requisição para cada link
let
    Source = Web.BrowserContents(URL),
    #"Extracted Table From Html" = Html.Table(Source, {{"Column1", ".edicao *"}, {"Column2", ".data-caderno"}, {"Column3", ".data-caderno2"}, {"Column4", ".btn_pagina + *"}, {"Column5", "li:nth-child(2)"}, {"Column6", ".btn_pagina:nth-child(6)"}, {"Column7", ".lista-caderno + *"}, {"Column8", ".btn.btn_visualizar"}, {"Column9", ".btn_pagina:nth-child(7)"}}, [RowSelector=".edicoes"]),
    #"Changed Type" = Table.TransformColumnTypes(#"Extracted Table From Html",{{"Column1", type text}, {"Column2", type date}, {"Column3", type date}, {"Column4", type text}, {"Column5", type text}, {"Column6", type text}, {"Column7", type text}, {"Column8", type text}, {"Column9", type text}})
in
    #"Changed Type"