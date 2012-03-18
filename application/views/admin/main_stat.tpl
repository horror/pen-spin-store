<table class="admin_table">
    <tr>
	<th>Раздел</th><th>Количество</th>
    </tr>
    [% FOREACH stat IN stats %]
	<tr>
	    [% FOREACH cell IN stat %]
	        <td>[% cell %]</td>
	    [% END %]
	</tr>
    [% END %]
</table>