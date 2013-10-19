@cls
set PATH=c:\D\dmd2\windows\bin;c:\D\dm\bin;

dfl -release beginner.d -gui
dfl -release charformat -gui
dfl -release client -gui
dfl -release combo.d -gui
dfl -release dfltest.d
dfl -release dnote dnote.res -gui
dfl -release draw -gui
dfl -release drop -gui
dfl -release droplist -gui
dfl -release helloworld -gui
dfl -release invoke -gui
dfl -release listbox -gui
dfl -release listview -gui
dfl -release mdi -gui
dfl -release paint -gui
dfl -release pictureviewer.d -gui
dfl -release rich -gui
dfl -release rps -gui
dmd -release rps_server ws2_32.lib
dfl -release shortcut.d -gui
dfl -release tabs -gui
dfl -release tip -gui
dfl -release tiplist -gui
dfl -release tray tray.res -gui
dfl -release treeview.d -gui
dfl -release dflhtmlget -gui
dfl -release progress -gui
dfl -release rctest rctest.res -gui
dfl -release dirlist -gui
dfl -release dirlistview -gui
dfl -release filedrop -gui
dfl -release scroller -gui
dfl -release regextester -gui
dfl -release listviewdirsort -gui
dfl -release status -gui


dfl -debug -ofbeginner_debug.exe beginner.d -gui
dfl -debug -ofcharformat_debug.exe charformat -gui
dfl -debug -ofclient_debug.exe client -gui
dfl -debug -ofcombo_debug.exe combo.d -gui
dfl -debug -ofdfltest_debug.exe dfltest
dfl -debug -ofdnote_debug.exe dnote dnote.res -gui
dfl -debug -ofdraw_debug.exe draw -gui
dfl -debug -ofdrop_debug.exe drop -gui
dfl -debug -ofdroplist_debug.exe droplist -gui
dfl -debug -ofhelloworld_debug.exe helloworld -gui
dfl -debug -ofinvoke_debug.exe invoke -gui
dfl -debug -oflistbox_debug.exe listbox -gui
dfl -debug -oflistview_debug.exe listview -gui
dfl -debug -ofmdi_debug.exe mdi -gui
dfl -debug -ofpaint_debug.exe paint -gui
dfl -debug -ofpictureviewer_debug.exe pictureviewer.d -gui
dfl -debug -ofrich_debug.exe rich -gui
dfl -debug -ofrps_debug.exe rps -gui
dmd -debug -ofrps_server_debug.exe rps_server ws2_32.lib
dfl -debug -ofshortcut_debug.exe shortcut.d -gui
dfl -debug -oftabs_debug.exe tabs -gui
dfl -debug -oftip_debug.exe tip -gui
dfl -debug -oftiplist_debug.exe tiplist -gui
dfl -debug -oftray_debug.exe tray tray.res -gui
dfl -debug -oftreeview_debug.exe treeview.d -gui
dfl -debug -ofdflhtmlget_debug.exe dflhtmlget -gui
dfl -debug -ofprogress_debug.exe progress -gui
dfl -debug -ofrctest_debug.exe rctest rctest.res -gui
dfl -debug -ofdirlist_debug.exe dirlist -gui
dfl -debug -ofdirlistview_debug.exe dirlistview -gui
dfl -debug -offiledrop_debug.exe filedrop -gui
dfl -debug -ofscroller_debug.exe scroller -gui
dfl -debug -ofregextester_debug.exe regextester -gui
dfl -debug -oflistviewdirsort_debug.exe listviewdirsort -gui
dfl -debug -ofstatus_debug.exe status -gui


@del *.obj *.map

