module PrrtyTest
using Toolips
using ToolipsSession
using ToolipsUploader
using Prrty
using Plots

myplot = plot(1:10, rand(10))
secplot = plot(1:20, 1:20)
"""
home(c::Connection) -> _
--------------------
The home function is served as a route inside of your server by default. To
    change this, view the start method below.
"""
function home(c::Connection)
    ppane = Prrty.plotpane("myplot", myplot)
    regpane = Prrty.pane("sidecontroller")
    examplebutton = button("examplebutton",
                        text = "click me to make the plot linear")
    on(c, examplebutton, "click") do cm::ComponentModifier
        set_text!(cm, "plotdescription", """What you see here is a
        linear range, 1:20, 1:20.
        """)
        Prrty.update!(cm, ppane, secplot)
    end
    inp = ToolipsUploader.fileinput(c, "myfile")
    myp = p("plotdescription", text = """ This is a plot that is generated with
    the range 1:10, and 10 random numbers.
    """)
    rangetest = rangeslider("myrangeslider", 1:50, value = 5, step = 5)
    on(c, rangetest, "change") do cm::ComponentModifier
        r = parse(Int64, cm[rangetest]["selected"])
        Prrty.update!(cm, ppane, plot(1:r, 1:r))
        set_text!(cm, "plotdescription",
        """This slider is ranged 1:50, the upper limit of the linear plot is updated accordingly.
        Your current selection is $r""")
    end

    style!(myp, "color" => "white")
    push!(regpane, h("myheading", 1, text = "my plot"), examplebutton, myp, inp,
    rangetest)
    pages = components(Prrty.page("mypage", components(h("myhead", 1,
    text = "hello HOJ/Person i made this for"))),
    Prrty.page("otherpage", components(regpane, ppane)))
    dash = Prrty.DashBoard(pages)
    write!(c, dash)
end

fourofour = route("404") do c
    write!(c, p("404message", text = "404, not found!"))
end

"""
start(IP::String, PORT::Integer, extensions::Vector{Any}) -> ::Toolips.WebServer
--------------------
The start function comprises routes into a Vector{Route} and then constructs
    a ServerTemplate before starting and returning the WebServer.
"""
function start(IP::String = "127.0.0.1", PORT::Integer = 8000,
    extensions::Vector = [Logger()])
    rs = routes(route("/", home), fourofour)
    server = ServerTemplate(IP, PORT, rs, extensions = extensions)
    server.start()
end

end # - module
