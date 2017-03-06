annfs = 18
tickfs = 18
res = 0.2
sff = "Bitstream Vera Sans"
ttf = "Consolas"

function plot_asympdf(x)
  if x == "asympdf"
    xest = [2/15 0 2-sqrt(3.5) 1/4]'
    est = [
      (xest[1] + res/1.5, asympdf(xest[1]), text("MMSE", font(sff, annfs))),
      (xest[2] + res/1.5, asympdf(xest[2]), text("MAP", font(sff, annfs))),
      (xest[3] + res/0.70, asympdf(xest[3]), text("MEDE", font(sff, annfs))),
#      (1/12, asympdf(1/12), "MP(0.5)"),
#      (1/6, asympdf(1/6), "MP(1)"),
      (xest[4] + res/1.5, asympdf(xest[4]), text("MP(1.5)", font(sff, annfs))),
    ]

    plt = plot(
      asympdf, -1, 1,
      label = "",
      annotations = est,

      guidefont = font(sff, tickfs),
      legendfont = font(sff, tickfs),
      tickfont = font(sff, tickfs),

      #line = (:black, 0.5, 3, :solid),
      linecolor = :black,
      linewidth = 4,
#      grid = false,
#      xticks = -1:res:1,
      xlims = (-1, 1),
      xlabel = "Possible locations",
#      yticks = 0.1:0.1:0.9,
      ylims = (0, 0.9),
      ylabel = "Posterior PDF",

      size = (1200, 600),

      fillrange = 0,
      fillalpha = 0.2,
      fillcolor = :gray,
    )
    scatter!(asympdf, xest,
         label = "",
         markershape = :hexagon,
         markersize = 12,
         markeralpha = 0.95,
         markercolor = :green,
         markerstrokewidth = 1,
         markerstrokealpha = 0.2,
         markerstrokecolor = :black,
#         markerstrokestyle = :dot
    )
    gui()
#    savefig(plt, "asympdf.pdf")
  else
    error("Invalid argument")
  end

  return plt
end
