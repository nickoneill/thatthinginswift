
import errno,sys
from pygments import highlight
from pygments.lexers import SwiftLexer
from pygments.formatters import HtmlFormatter

# code = """class ViewController: UIViewController {
#     let topView: UIView = {
#         let view = UIView()
#         view.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
#         view.backgroundColor = UIColor.redColor()
#         return view
#     }()
# }
# """

if len(sys.argv) != 2:
    print("no code to highlight")
    sys.exit(errno.EACCES)

code = sys.argv[1]

# formatter = ImageFormatter(font_name='Monaco')
formatter = HtmlFormatter(style="monokai")
html = highlight(code, SwiftLexer(), formatter)
css = formatter.get_style_defs('.highlight')
css = "html,body{ background-color: #000; font-size: 36px; } .outer{ display: table; height: 614px;} pre{ width: 1184px; overflow: hidden; }  .highlight{ display: table-cell; vertical-align: middle; }" + css
html = "<html><head><style>" + css + "</style><body><div class='outer'>" + html + "</div></body></html>"
open("previewCode.html", "w").write(html)
