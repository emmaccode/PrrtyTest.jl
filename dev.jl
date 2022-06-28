#==
dev.jl is an environment file. This file loads and starts servers, and
defines environmental variables.
==#
using Pkg; Pkg.activate(".")
using Toolips
using ToolipsSession
using ToolipsUploader
using Revise
using PrrtyTest

IP = "127.0.0.1"
PORT = 8008
#==
Extension description
Logger -> Logs messages into both a file folder and the terminal.
Files -> Routes the files from the public directory.
Session -> ToolipsSession; allows us to make Servables reactive. See ?(on)
==#
extensions = [Logger(), Files("public"), Session(), ToolipsUploader.Uploader()]
PrrtyTestServer = PrrtyTest.start(IP, PORT, extensions)
