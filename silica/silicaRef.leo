<?xml version="1.0" encoding="utf-8"?>
<!-- Created by Leo (http://webpages.charter.net/edreamleo/front.html) -->
<?xml-stylesheet ekr_test?>
<leo_file xmlns:leo="http://www.leo-editor.org/2011/leo" >
<leo_header file_format="2" tnodes="0" max_tnode_index="0" clone_windows="0"/>
<globals body_outline_ratio="0.5" body_secondary_ratio="0.5">
	<global_window_position top="50" left="50" height="500" width="700"/>
	<global_log_window_position top="0" left="0" height="0" width="0"/>
</globals>
<preferences/>
<find_panel_settings/>
<vnodes>
<v t="peckj.20130604112211.4466"><vh>Startup</vh>
<v t="peckj.20130604112211.4467"><vh>@settings</vh></v>
<v t="peckj.20130604112211.4468"><vh>Buttons</vh>
<v t="peckj.20130604112211.4469"><vh>@button timeit</vh></v>
<v t="peckj.20130604112211.4470"><vh>@button profile</vh></v>
</v>
</v>
<v t="peckj.20130604112211.2164" a="E"><vh>Code</vh>
<v t="peckj.20130604112211.2170"><vh>autoexec</vh>
<v t="peckj.20130604112211.2172"><vh>@file ../autoexec.silica</vh></v>
</v>
<v t="peckj.20130604112211.2165"><vh>Launcher</vh>
<v t="peckj.20130604112211.2162"><vh>@file ../silica.py</vh></v>
</v>
<v t="peckj.20130604112211.2148" a="E"><vh>silica</vh>
<v t="peckj.20130604112211.2146"><vh>@file __init__.py</vh></v>
<v t="peckj.20130604112211.2149" a="E"><vh>core</vh>
<v t="peckj.20130604112211.2147"><vh>@file core/__init__.py</vh></v>
<v t="peckj.20130604112211.2150" a="E"><vh>@file core/runSilica.py</vh></v>
</v>
<v t="peckj.20130604112211.2151"><vh>examples</vh>
<v t="peckj.20130604112211.2153"><vh>@edit examples/readme_example.silica</vh></v>
<v t="peckj.20130604112211.2154"><vh>@edit examples/glass_twopages.silica</vh></v>
<v t="peckj.20130604112211.2155"><vh>@edit examples/john.silica</vh></v>
<v t="peckj.20130604112211.2156"><vh>@edit examples/moondog_pastoral.silica</vh></v>
<v t="peckj.20130604112211.2157"><vh>@edit examples/quest_examples.silica</vh></v>
</v>
<v t="peckj.20130604112211.2152"><vh>test</vh>
<v t="peckj.20130604112211.2158"><vh>@edit test/scale_test.silica</vh></v>
<v t="peckj.20130604112211.2159"><vh>@edit test/concurrent_test.silica</vh></v>
<v t="peckj.20130604112211.2160"><vh>@edit test/embed_voice_test.silica</vh></v>
<v t="peckj.20130604112211.2161"><vh>@edit test/namespace_test.silica</vh></v>
</v>
</v>
</v>
<v t="peckj.20130604112211.2166"><vh>Docs</vh>
<v t="peckj.20130604112211.2168"><vh>@file ../README.md</vh></v>
</v>
</vnodes>
<tnodes>
<t tx="peckj.20130604112211.2148"></t>
<t tx="peckj.20130604112211.2149"></t>
<t tx="peckj.20130604112211.2151"></t>
<t tx="peckj.20130604112211.2152"></t>
<t tx="peckj.20130604112211.2164"></t>
<t tx="peckj.20130604112211.2165"></t>
<t tx="peckj.20130604112211.2166"></t>
<t tx="peckj.20130604112211.2170"></t>
<t tx="peckj.20130604112211.4466"></t>
<t tx="peckj.20130604112211.4467">@ 
  keybindings - for unit-testing
@c

run-selected-unit-tests-locally = Alt-4
run-marked-unit-tests-locally = Alt-5
run-all-unit-tests-locally = Alt-6
</t>
<t tx="peckj.20130604112211.4468">@language python</t>
<t tx="peckj.20130604112211.4469">@language python
c.testManager.runTimerOnNode(p,count=100)</t>
<t tx="peckj.20130604112211.4470">@language python
c.testManager.runProfileOnNode(p,outputPath='test/silicaProfile.txt')</t>
</tnodes>
</leo_file>
