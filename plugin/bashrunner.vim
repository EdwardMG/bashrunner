fu! s:Setup()
ruby << RUBY
module BashRunner
  def self.eval_lines(start_lnum, end_lnum='.') = `#{Ev.getline(start_lnum, end_lnum).join("\n")}`.split("\n")
  def self.append(lines, t='.')
    Ev.append(t, lines.map {|x| "#{leading_spaces}# " + x.sq })
    Ex.redraw! # if there's any error executing the command draw state can be bugged
  end
  def self.leading_spaces                       = Ev.getline('.').match(/^(\s*)/)[1]
  def self.eval_visual_selection                = append `#{VisualSelection.new.inner.join("\n")}`.split("\n"), "'>"
  def self.eval_current_line                    = append eval_lines('.')
  def self.eval_from_top                        = append eval_lines(1, '.')
end
RUBY
endfu

call s:Setup()

augroup BashRunner
  autocmd!

  au BufEnter *.sh nno <buffer> gm :ruby BashRunner.eval_current_line<CR>
  au BufEnter *.sh vno <buffer> gm :ruby BashRunner.eval_visual_selection<CR>
  au BufEnter *.sh nno <buffer> gj :ruby BashRunner.eval_from_top<CR>
augroup END
