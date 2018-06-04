<?php
	if (isset($_POST))
	{
		print_r(($_POST['list']));
	}
	else
	{
		var_dump('no post');
	}
?>