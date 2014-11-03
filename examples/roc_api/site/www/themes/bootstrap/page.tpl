<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>ROC- Layout with defualt Regions</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.min.css" rel="stylesheet">
    <style type="text/css">
        
    </style>
    <script src="http://code.jquery.com/jquery-1.10.2.min.js"></script>
    <script src="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/js/bootstrap.min.js"></script>
</head>
<body>
<head>
<title>{$title/}</title>
</head>
<body>
  <!-- Page Top -->
  {$region_top/}
  
  <!-- Body -->
  <div class='container-fluid'>
    
    <!-- Page Header -->
    {$region_header/}

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
