@rem Build checker
@rem set PATH=C:\D\dmd.2.064.2\windows\bin;c:\D\dm\bin;
@rem set PATH=C:\D\dmd.2.065.0\windows\bin;
set PATH=C:\D\dmd.2.066.0\windows\bin;

set RELEASE=-version=DFL_UNICODE  dfl.lib -L/exet:nt/su:windows:4.0
set DEBUG=-g -debug -version=DFL_UNICODE  dfl_debug.lib -L/exet:nt/su:windows:4.0

dmd  beginner.d %RELEASE%
dmd  charformat %RELEASE%
dmd  client %RELEASE%
dmd  combo.d %RELEASE%
dmd  dfltest.d %RELEASE%
dmd  dnote dnote.res %RELEASE%
dmd  draw %RELEASE%
dmd  drop %RELEASE%
dmd  droplist %RELEASE%
dmd  helloworld %RELEASE%
dmd  invoke %RELEASE%
dmd  listbox %RELEASE%
dmd  listview %RELEASE%
dmd  mdi %RELEASE%
dmd  paint %RELEASE%
dmd  pictureviewer.d %RELEASE%
dmd  rich %RELEASE%
dmd  rps %RELEASE%
dmd -release rps_server ws2_32.lib %RELEASE%
dmd  shortcut.d %RELEASE%
dmd  tabs %RELEASE%
dmd  tip %RELEASE%
dmd  tiplist %RELEASE%
dmd  tray tray.res %RELEASE%
dmd  treeview.d %RELEASE%
dmd  dflhtmlget %RELEASE%
dmd  progress %RELEASE%
dmd  rctest rctest.res %RELEASE%
dmd  dirlist %RELEASE%
dmd  dirlistview %RELEASE%
dmd  filedrop %RELEASE%
dmd  scroller %RELEASE%
dmd  regextester %RELEASE%
dmd  listviewdirsort %RELEASE%
dmd  status %RELEASE%
dmd  toolbar toolbar.res %RELEASE%

goto end:

dmd  -ofbeginner_debug.exe beginner.d %DEBUG%
dmd  -ofcharformat_debug.exe charformat %DEBUG%
dmd  -ofclient_debug.exe client %DEBUG%
dmd  -ofcombo_debug.exe combo.d %DEBUG%
dmd  -ofdfltest_debug.exe dfltest %DEBUG%
dmd  -ofdnote_debug.exe dnote dnote.res %DEBUG%
dmd  -ofdraw_debug.exe draw %DEBUG%
dmd  -ofdrop_debug.exe drop %DEBUG%
dmd  -ofdroplist_debug.exe droplist %DEBUG%
dmd  -ofhelloworld_debug.exe helloworld %DEBUG%
dmd  -ofinvoke_debug.exe invoke %DEBUG%
dmd  -oflistbox_debug.exe listbox %DEBUG%
dmd  -oflistview_debug.exe listview %DEBUG%
dmd  -ofmdi_debug.exe mdi %DEBUG%
dmd  -ofpaint_debug.exe paint %DEBUG%
dmd  -ofpictureviewer_debug.exe pictureviewer.d %DEBUG%
dmd  -ofrich_debug.exe rich %DEBUG%
dmd  -ofrps_debug.exe rps %DEBUG%
dmd -debug -ofrps_server_debug.exe rps_server ws2_32.lib %DEBUG%
dmd  -ofshortcut_debug.exe shortcut.d %DEBUG%
dmd  -oftabs_debug.exe tabs %DEBUG%
dmd  -oftip_debug.exe tip %DEBUG%
dmd  -oftiplist_debug.exe tiplist %DEBUG%
dmd  -oftray_debug.exe tray tray.res %DEBUG%
dmd  -oftreeview_debug.exe treeview.d %DEBUG%
dmd  -ofdflhtmlget_debug.exe dflhtmlget %DEBUG%
dmd  -ofprogress_debug.exe progress %DEBUG%
dmd  -ofrctest_debug.exe rctest rctest.res %DEBUG%
dmd  -ofdirlist_debug.exe dirlist %DEBUG%
dmd  -ofdirlistview_debug.exe dirlistview %DEBUG%
dmd  -offiledrop_debug.exe filedrop %DEBUG%
dmd  -ofscroller_debug.exe scroller %DEBUG%
dmd  -ofregextester_debug.exe regextester %DEBUG%
dmd  -oflistviewdirsort_debug.exe listviewdirsort %DEBUG%
dmd  -ofstatus_debug.exe status %DEBUG%
dmd  -oftoolbar_debug.exe toolbar toolbar.res %DEBUG%

:end
@del *.obj *.map
@del *.exe
pause
