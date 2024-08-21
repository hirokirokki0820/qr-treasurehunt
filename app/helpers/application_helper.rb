module ApplicationHelper
  require "rqrcode"
  require "rqrcode_png"

  def qrcode(url, size)
    qrcode = RQRCode::QRCode.new(url)
    svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: size,
      standalone: true,
      use_path: true
    ).html_safe
  end
end
