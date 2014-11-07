<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>ROC- Layout with defualt Regions</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css">

    <style type="text/css">
        
    </style>

    <!-- Latest compiled and minified CSS -->

  <!-- Optional theme -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap-theme.min.css">

    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
    <script src="http://code.jquery.com/jquery-1.10.2.min.js"></script>
</head>
<body>
<head>
<title>{$page_title/}</title>
</head>
<body>
  <!-- Page Top -->
  {if isset="$top"}
    {$region_top/}
  {/if}
  <!-- Body -->
  <div class='container-fluid'>
    
    <!-- Page Header -->
    <div id="header">
       {include file="tpl/page_header.tpl"/}
    </div> 
    
    <!-- General Page Content -->
    <div id='content' class='row-fluid'>
    

      <!-- Left Side Bard sidebar_first -->
      {$region_sidebar_first/}

        <!-- Highlighted, Help, Content -->      
        <div class='span8 main'>
          <!-- Highlighted Section -->
          {$region_highlighted/}
 

          <!-- Help Section -->
          {$region_help/}
          

          <!-- Main Content Section -->
           {$region_main/}   
        </div>

      <!-- Right Side Bard sidebar_second-->
      {$region_sidebar_second/}
      </div>
    </div>

  <!--Page footer -->
  {$region_footer/}

  <!-- Page Bottom -->
  {$region_bottom/}
</body>
<script type="text/javascript">

</script>
</body>
</html>
