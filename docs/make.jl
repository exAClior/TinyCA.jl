using TinyCA
using Documenter

DocMeta.setdocmeta!(TinyCA, :DocTestSetup, :(using TinyCA); recursive=true)

makedocs(;
    modules=[TinyCA],
    authors="Yusheng Zhao <yushengzhao2020@outlook.com> and contributors",
    sitename="TinyCA.jl",
    format=Documenter.HTML(;
        canonical="https://exAClior.github.io/TinyCA.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/exAClior/TinyCA.jl",
    devbranch="main",
)
