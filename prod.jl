using Pkg; Pkg.activate(".")
using Toolips
using ToolipsSession
using PrrtyTest

IP = "127.0.0.1"
PORT = 8008
extensions = [Logger(), Files("public"), Session()]
PrrtyTestServer = PrrtyTest.start(IP, PORT, extensions)
