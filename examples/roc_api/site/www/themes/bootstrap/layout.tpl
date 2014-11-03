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
<title>ROC CMS - A responsive layout</title>
</head>
<body>
  <!-- Page Top -->
  {include file="tpl/page_top.tpl"/} 
  
  <!-- Body -->
  <div class='container-fluid'>
    
    <!-- Page Header -->
    {include file="tpl/page_header.tpl"/} 

    <!-- General Page Content -->
    <div id='content' class='row-fluid'>
    

      <!-- Left Side Bard sidebar_first -->
      {include file="tpl/left_sidebar.tpl"/} 

        <!-- Highlighted, Help, Content -->      
        <div class='span8 main'>
          <!-- Highlighted Section -->
          {include file="tpl/highlighted_section.tpl"/} 


          <!-- Help Section -->
          {include file="tpl/help_section.tpl"/}   
          

          <!-- Main Content Section -->
           {include file="tpl/main_content.tpl"/}    
        </div>

      <!-- Right Side Bard sidebar_second-->
      {include file="tpl/right_sidebar.tpl"/}     
      </div>
    </div>

  <!--Page footer -->
  {include file="tpl/page_footer.tpl"/}     

  <!-- Page Bottom -->
  {include file="tpl/page_bottom.tpl"/}     
</body>
<script type="text/javascript">

</script>
</body>
</html>
