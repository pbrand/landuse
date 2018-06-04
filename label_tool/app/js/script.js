$(document).ready(function()
{
	//init
	function vw($size)
	{
		if (typeof $size !== 'undefined')
		{
			if ($.isNumeric($size))
			{
				return $(window).width()*($size/100);
			}
		}

		return $(window).width()/100;
	}
	function vh($size)
	{
		if (typeof $size !== 'undefined')
		{
			if ($.isNumeric($size))
			{
				return $(window).height()*($size/100);
			}
		}
		return $(window).height()/100;
	}

	function selectAndChange(key, value)
	{
		var objects = canvas.getObjects();
		for (var i = objects.length - 1; i >= 0; i--)
		{
			objects[i][key] = value;
			//objects[i].set({key: value});
		}
	}

	function checkAndChange(e)
	{
		var objects = canvas.getObjects();
		for (var i = objects.length - 1; i >= 0; i--)
		{
			if (objects[i]['class'] == 'brush')
			{
				canvas.setActiveObject(objects[i]);
				canvas.remove(canvas.getActiveObject());
			}
		}

		if ($(e).hasClass('active'))
		{
			$('.draw').removeClass('active');
			$('#pop_out').addClass('disable');
			$(e).find('i').addClass('far').removeClass('fas');
			
			canvas.defaultCursor = 'auto';
			canvas.hoverCursor = 'pointer';
			canvas.moveCursor = 'move';

			selectAndChange('selectable', true);
			canvas.isDrawingMode = false;
		}
		else
		{
			$('.draw').removeClass('active');
			$(e).addClass('active');
			$('.draw i').addClass('far').removeClass('fas');
			$(e).find('i').addClass('fas').removeClass('far');
			$('#pop_out').removeClass('disable');
			
			canvas.hoverCursor = 'crosshair';
			canvas.defaultCursor = 'crosshair';
			canvas.moveCursor = 'crosshair';

			selectAndChange('selectable', false);
			canvas.isDrawingMode = false;
		}
	}

	function clearEvents()
	{
		canvas.__eventListeners = {};
		canvas.on(
		{
			'object:moving': function(e)
			{
				e.target.opacity = 0.25;
			},
			'object:modified': function(e)
			{
				e.target.opacity = 0.5;
			}
		});
	}

	var c, canvas;
	var isActiveS = false;
	var color;
	var class_name = 'undefined';
	var classes = [];
	var brushSize = 10;

	$('*').keydown(function(event)
	{
		if(event.which == 219 || event.which == 221)
		{
			event.preventDefault();

			var oldB = brushSize;
			var check = false;
			var brushObj;
			
			if(event.which == 219)
			{
				if (brushSize > 0) 
				{
					brushSize = brushSize - 1;
				}
			}
			else
			{
				brushSize = brushSize + 1;
			}

			var objects = canvas.getObjects();
			for (var i = objects.length - 1; i >= 0; i--)
			{
				if(objects[i]['class'] == 'brush')
				{				
					check = true;
					brushObj = objects[i];
				}
			}

			if (check != false)
			{
				brushObj.set({ rx: brushSize / 2, ry: brushSize / 2});

				var x = brushObj['left'] + oldB / 2;
				var y = brushObj['top'] + oldB / 2;
				brushObj.set({ left: (x - brushSize / 2), top: (y - brushSize / 2)});

				brushObj.set({ rx: brushSize / 2, ry: brushSize / 2});
				canvas.freeDrawingBrush.width = brushSize;
			}

			canvas.renderAll();
		}
	});

	var files = [
		{
			name: 'Project_deforstation',
			images: ['utrecht.jpg']
		},
		{
			name: 'Project_Industry',
			images: ['utrecht.jpg', 'utrecht_2.jpg']
		}
	];

	//canvas size
	function init_canvas(name, image)
	{
		isActiveS = false;
		color = undefined;
		class_name = 'undefined';
		classes = [];
		brushSize = 10;

		$('#container').removeClass('disable');
		$('#select_file').addClass('disable');

		$('#container').append('<canvas id="c"></canvas>');
		setTimeout(function() {}, 1);

		c = document.getElementById('c');
		if (vh() > vw())
		{
			c.height = vw(99);
			c.width = vw(99);
		}
		else if (vh() < vw())
		{
			c.width = vh(99);
			c.height = vh(99);
		}
		else
		{
			c.height = vh(99);
			c.width = vw(99);
		}

		$ch = c.height;
		$cw = c.width;

		//fabric
		canvas = new fabric.Canvas('c');
		canvas.uniScaleTransform = true;
		canvas.stopContextMenu = true;
		canvas.hoverCursor = 'pointer';

		$('.draw').removeClass('active');
		$('#pop_out').addClass('disable');

		c.style.backgroundImage = 'url(../' + name + '/plaatjes/' + image + ')';

		$('#pop_out ul li').remove();

		$.ajax(
		{
			url: '../' + name + '/klassen.csv',
			type: 'get',
			dataType: 'text',
			success: function(data)
			{
				data = data.split("\n");
				data.forEach(function(item)
				{
					item = item.split(",");
					if (typeof(item[0]) != 'undefined' && typeof(item[2]) != 'undefined')
					{
						$('#pop_out ul').append('<li><a href="#"><div class="color_box" style="background:' + item[2] + '"></div><span>' + item[0] + '</span></a></li>');
					}
				});

				setTimeout(function() {}, 1);

				$('nav a').click(function(event)
				{
					event.preventDefault();
				});

				$('#pop_out a').click(function()
				{
					color = new RGBColor($(this).children('div').attr("style").split(":")[1].toLowerCase()).toHex();
					$('#pop_out a').removeClass('active');
					$(this).addClass('active');

					selectAndChange('selectable', false);

					class_name = $(this).children('span')[0].innerHTML;

					$('.main .active').triggerHandler('click');
				});

			},
			error: function(jqXHR, textStatus, errorThrow)
			{
				console.log(jqXHR['responseText']);
			}
		});

		//Button Logic
		$('nav a').click(function(event)
		{
			event.preventDefault();
		});

				//Zooming
		$('#zoom_in').click(function()
		{
			$zoom_level = canvas.getZoom() + 0.25;
			canvas.setZoom($zoom_level);
			canvas.setWidth($cw * $zoom_level);
			canvas.setHeight($ch * $zoom_level);
		});

		$('#zoom_out').click(function()
		{
			$zoom_level = canvas.getZoom() - 0.25;
			canvas.setZoom($zoom_level);
			canvas.setWidth($cw * $zoom_level);
			canvas.setHeight($ch * $zoom_level);
		});

		//free draw
		$('#free_draw').click(function(e)
		{
			clearEvents();
			
			if(e.hasOwnProperty('originalEvent'))
			{
				checkAndChange(this);
			}

			if ($(this).hasClass('active'))
			{
				var brush = false;
				canvas.freeDrawingBrush.width = brushSize;
				if (typeof(color) != 'undefined')
				{
					canvas.freeDrawingBrush.color = color;

					var objects = canvas.getObjects();
					for (var i = objects.length - 1; i >= 0; i--)
					{
						if(objects[i]['class'] == 'brush')
						{
							brush = true;
							objects[i].set({ fill: color});
							objects[i].set({ opacity: 0.5});
						}
					}

					if (brush == false)
					{
						shape = new fabric.Ellipse(
						{
							class: 'brush',
							left: 0,
							top: 0,
							rx: brushSize / 2,
							ry: brushSize / 2,
							fill: color,
							opacity: 0,
							selectable: false,
							hoverCursor: 'copy'
						});
					}

					canvas.add(shape);
					shape.setCoords();
					canvas.discardActiveObject();

					canvas.on('mouse:move', function(o)
					{
						var pointer = canvas.getPointer(o.e);
						var x = pointer.x - (brushSize / 2);
						var y = pointer.y - (brushSize / 2);

						if(shape['opacity'] == 0)
						{
							shape.set({ opacity: 0.5});
						}

						shape.set({ left: x, top: y});

						canvas.renderAll();
					});

					canvas.on('mouse:up', function(o)
					{
						selectAndChange('opacity', 0.5);
						selectAndChange('selectable', false);
						canvas.discardActiveObject();
					});

					canvas.isDrawingMode = true;
				}
			}
			else
			{
				canvas.isDrawingMode = false;
			}

		});

		//shape draws
		$('#free_form').click(function(e)
		{
			clearEvents();

			if(e.hasOwnProperty('originalEvent'))
			{
				checkAndChange(this);
			}

			if ($(this).hasClass('active'))
			{
				var shape, isDown, points, x, y, minX, minY;

				canvas.on('mouse:down', function(o)
				{
					if (typeof(color) != 'undefined')
					{
						canvas.discardActiveObject();

						var pointer = canvas.getPointer(o.e);
						x = pointer.x;
						y = pointer.y;

						if (x < minX || minX == undefined)
						{
							minX = x;
						}
						if (y < minY || minY == undefined)
						{
							minY = y;
						}

						if(typeof(points) == 'undefined')
						{
							points = [{x: x, y: y}];

							shape = new fabric.Ellipse(
							{
								class: 'temp',
								left: x - 2,
								top: y - 2,
								rx: 2,
								ry: 2,
								fill: 'hotpink',
								opacity: 1,
								selectable: false,
								hoverCursor: 'copy'
							});

							canvas.add(shape);
							shape.setCoords();
							canvas.discardActiveObject();
						}
						else
						{
							if (x >= (points[0].x - 2) && x <= (points[0].x + 2) && y >= (points[0].y - 2) && y <= (points[0].y + 2))
							{
								var obj = canvas.getObjects();
								var sel = [];

								for (var i = 0; i < obj.length; i++)
								{
									if (obj[i].class == 'temp')
									{
										sel.push(i);
									}
								}

								sel = sel.reverse();
								for(i = 0; i < sel.length; i++)
								{
									canvas.setActiveObject(obj[sel[i]]);
									canvas.remove(canvas.getActiveObject());
								}

								var polygon = new fabric.Polygon(points,
								{
									left: minX,
									top: minY,
									fill: color,
									class: class_name,
									selectable: false,
									opacity: 0.5
								});

								polygon.perPixelTargetFind = true;
								polygon.targetFindTolerance = 4;

								canvas.add(polygon);
								polygon.setCoords();
								canvas.discardActiveObject();
								points = undefined;
								minX = 90000;
								minY = 90000;
							}
							else
							{
								var len = points.length;
								points.push({x: x, y: y});
								var coords = [points[len - 1].x, points[len - 1].y, points[len].x, points[len].y];
								line = new fabric.Line(coords,
								{
									class: 'temp',
									fill: color,
									stroke: color,
									strokeWidth: 1,
									selectable: false
								});

								canvas.add(line);
								line.setCoords();
							}
						}						
					}
				});
			}

		});

		$('.shape_draw').click(function(e)
		{
			clearEvents();
			
			var draw_type = $(this).attr('id');

			if(e.hasOwnProperty('originalEvent'))
			{
				checkAndChange(this);
			}
			
			if ($(this).hasClass('active') && typeof(color) != undefined)
			{
				var shape, isDown, origX, origY;

				canvas.on('mouse:down', function(o)
				{
					if (typeof(color) != 'undefined')
					{
						canvas.discardActiveObject();

						isDown = true;
						var pointer = canvas.getPointer(o.e);
						origX = pointer.x;
						origY = pointer.y;
						var pointer = canvas.getPointer(o.e);

						if (draw_type == 'square')
						{
							shape = undefined;
							shape = new fabric.Rect(
							{
								left: origX,
								top: origY,
								width: pointer.x-origX,
								height: pointer.y-origY,
								class: class_name,
								fill: color,
								opacity: 0.5,
								selectable: false
							});
						}
						else if (draw_type == 'circle')
						{
							shape = undefined;
							shape = new fabric.Ellipse(
							{
								left: origX,
								top: origY,
								rx: pointer.x-origX,
								ry: pointer.y-origY,
								class: class_name,
								fill: color,
								opacity: 0.5,
								selectable: false
							});
						}

						shape.perPixelTargetFind = true;
						shape.targetFindTolerance = 4;

						canvas.add(shape);
						shape.setCoords();
						canvas.discardActiveObject();
					}
				});

				canvas.on('mouse:move', function(o)
				{
					if (!isDown) return;
					var pointer = canvas.getPointer(o.e);
					if (draw_type == 'square')
					{
						if(origX>pointer.x)
						{
							shape.set({ left: Math.abs(pointer.x)});
						}

						if(origY>pointer.y)
						{
							shape.set({ top: Math.abs(pointer.y)});
						}
						
						shape.set({ width: Math.abs(origX - pointer.x)});
						shape.set({ height: Math.abs(origY - pointer.y)});
					}
					else if (draw_type == 'circle')
					{
						var rx = Math.abs(origX - pointer.x)/2;
						var ry = Math.abs(origY - pointer.y)/2;
						if (rx > shape.strokeWidth)
						{
							rx -= shape.strokeWidth/2
						}
						if (ry > shape.strokeWidth)
						{
						  ry -= shape.strokeWidth/2
						}

						shape.set({ rx: rx, ry: ry});
						
						if(origX>pointer.x)
						{
							shape.set({originX: 'right'});
						}
						else
						{
							shape.set({originX: 'left'});
						}

						if(origY>pointer.y)
						{
							shape.set({originY: 'bottom'});
						}
						else
						{
							shape.set({originY: 'top'});
						}
					}						
					
					canvas.renderAll();
				});

				canvas.on('mouse:up', function(o)
				{
					shape.setCoords();
					isDown = false;
					shape = undefined;
				});
			}
		});
		
		//save
		$('#save').click(function()
		{
			selectAndChange('opacity', 1);

			var objects = canvas.getObjects();
			for (var i = objects.length - 1; i >= 0; i--)
			{

				if (objects[i]['class'] == 'brush')
				{
					canvas.setActiveObject(objects[i]);
					canvas.remove(canvas.getActiveObject());
				}
			}

			canvas.renderAll();

			var svg = canvas.toSVG();
			/*console.log($.post('save.php', svg));
			window.open('save.php');
			console.log(svg);*/

			$('body').append('<form action="save.php" method="POST" target="_blank" id="myform"><input type="hidden" name="list" id="list-data"/></form>');
			$('#list-data').val(svg);
			$('#myform').submit();
			$('form').remove();

			selectAndChange('opacity', 0.5);
			canvas.renderAll();
		});

		$('.delete').click(function()
		{
			var objects = canvas.getActiveObject();
			if(typeof(objects) != 'undefined')
			{
				canvas.remove(objects);
			}
			else
			{
				alert('No object selected.');
			}
		});

		$('nav.side a').click(function()
		{
			clearEvents();

			$('canvas, .canvas-container').remove();
			$('#container').addClass('disable');
			$('#select_file').removeClass('disable');
			$('#container a').off('click');
		});
	}

	function init_files()
	{
		files.forEach(function(element)
		{
			$('#select_file').append('<h1>' + element['name'] + '</h1><ul id="' + element['name'] + '"></ul>');
			element['images'].forEach(function(e)
			{
				var select = '#select_file ul#' + element['name'];
				$(select).append('<li><a href="#">' + e + '</a></li>');
			});
		});

		$('#select_file a').click(function(event)
		{
			event.preventDefault();
		});

		$('#select_file a').click(function()
		{
			init_canvas($(this).parent().parent().attr('id'), this.innerHTML);
		});
	}

	init_files();

	//Button Logic
	/*$('nav a, #select_file a').click(function(event)
	{
		event.preventDefault();
	});*/

		/*//Panning
		$('#pan').click(function()
			{
				$(this).toggleClass('active');
				if($(this).hasClass('active'))
				{
					if (canvas.getZoom() > 1)
					{
						canvas.defaultCursor = 'move';
					}
					else
					{
						$(this).toggleClass('active');
					}
				}
				else
				{
					canvas.defaultCursor = 'auto';
				}
			});

		canvas.on('mouse:move', function (e)
		{
			if ($('#pan').hasClass('active') && e && e.e)
			{
				//canvas.on('mouse:down', function ( event )
				//{
				//	event.preventDefault();
					var delta = new fabric.Point(e.e.movementX, e.e.movementY);
					console.log(delta, delta['x'] / 5, delta['y'] / 5);
					console.log(canvas.getZoom());
					$(document).scrollTop($(document).scrollTop() + (delta['y'] / 5));
					$(document).scrollLeft($(document).scrollLeft() + (delta['x'] / 5));
				//});
			}
		});*/

	//Key logic
	/*$('*').keypress(function( event )
	{
		if( event.which == 32 )
		{
			event.preventDefault();
			$('#pan').click();
		}
	});*/
});