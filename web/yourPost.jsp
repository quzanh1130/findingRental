

<%-- 
    Document   : findRental
    Created on : Jul 8, 2023, 1:52:43 AM
    Author     : Tan Phat
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="java.text.DecimalFormat, java.text.NumberFormat, java.util.Locale" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.Base64" %>
<%@page import="java.util.ArrayList" %>
<%@ page import="model.Post" %>
<%@ page import="com.google.gson.Gson" %>
<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap"
              rel="stylesheet">
        <title>Your Post</title>

        <!-- Bootstrap core CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">

        <!-- Additional CSS Files -->
        <link rel="stylesheet" href="./assets/css/fontawesome.css">
        <link rel="stylesheet" href="./assets/css/style.css">
        <link rel="stylesheet" href="./assets/css/owl.css">
        <link rel="stylesheet" href="./assets/css/animate.css">
        <link rel="stylesheet" href="https://unpkg.com/swiper@7/swiper-bundle.min.css" />
    </head>

    <body>

        <%! 
            public String inputStreamToBase64(InputStream inputStream) throws IOException {
                ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
                byte[] imageBytes = outputStream.toByteArray();
                return Base64.getEncoder().encodeToString(imageBytes);
            }

            public String formatCurrency(double price) {
                NumberFormat formatter = NumberFormat.getNumberInstance(Locale.US);
                DecimalFormat decimalFormat = (DecimalFormat) formatter;
                decimalFormat.applyPattern("#,### VNĐ");
                return decimalFormat.format(price);
            }
        %>


        <!-- ***** Preloader Start ***** -->
        <div id="js-preloader" class="js-preloader">
            <div class="preloader-inner">
                <span class="dot"></span>
                <div class="dots">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
            </div>
        </div>
        <!-- ***** Preloader End ***** -->


        <!-- ***** Header Area Start ***** -->
        <header class="header-area">
            <nav class="container main-nav">
                <!-- ***** Logo Start ***** -->
                <a href="./home" class="logo">
                    <!--<img src="../src/java/imgs/logo2.jpg" alt="">-->
                    <img style="object-fit: contain;" src="./assets/images/logo3.png" alt="">
                </a>
                <!-- ***** Logo End ***** -->

                <!-- ***** Menu Start ***** -->
                <% 
                    String user = null;
                    HttpSession section = request.getSession(false);
                    if (session != null) {
                        user = (String) session.getAttribute("username");
                    } 
                %>

                <!-- ***** Menu Start ***** -->
                <ul class="nav" style="align-items: center;">
                    <li class="effect"><a href="./home" class="active">Home</a></li>
                    <li class="effect"><a href="./rental">Rental</a></li>
                    <li class="effect"><a href="./instruction">Instruction</a></li>
                    <li class="effect"><a href="./post">Post</a></li>
                        <% 
                            if ("admin".equals(session.getAttribute("usertype"))) {
                        %>
                    <li class="effect"><a href="./admin">Admin</a></li>
                        <%
                            }
                        %>
                    <li class="dropdown">
                        <a class="nav-link dropdown-toggle" href="" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fas fa-user"></i> <%= user %>
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="./profile">Profile</a>
                            <a class="dropdown-item" href="./post">Post</a>
                            <a class="dropdown-item" href="./yourpost">Your Post</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="./login">Logout</a>
                        </div>
                    </li>
                </ul>

                <a class='menu-trigger'>
                    <span>Menu</span>
                </a>
                <!-- ***** Menu End ***** -->
            </nav>
        </header>
        <!-- ***** Header Area End ***** -->

        <div class="container">
            <div id="toast" style="z-index: 1000000;"></div>
            <!-- ***** Page content Start ***** -->
            <div class="row page-content-find">
                <div class="col-lg-12 col-sm-12 main-content">

                    <%
                        ArrayList<Post> postList = new ArrayList<Post>();
                        if (session.getAttribute("yourList") != null) {
                            postList = (ArrayList<Post>) session.getAttribute("yourList");
                        } else {
                            postList = new ArrayList<Post>(); // Initialize with an empty ArrayList
                        }

                        int currentPage = (request.getParameter("page") != null) ? Integer.parseInt(request.getParameter("page")) : 1;
                        int itemsPerPage = 10; // Number of items per page
                        int totalItems = postList.size(); // Total number of items from the database
                        int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage); // Calculate total number of pages

                        int startIndex = (currentPage - 1) * itemsPerPage;
                        int endIndex = Math.min(startIndex + itemsPerPage, totalItems);
                    
                        if (startIndex >= totalItems) {
                    %>

                    <div class="item-find">
                        <div class="row">
                            <div class="col-12 des text-center">
                                <div class="alert alert-danger text-center">
                                    <strong>Bạn chưa có bài viết nào.</strong>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% 
                        } else {
                            for (int i = startIndex; i < endIndex; i++) {
                                Post post = postList.get(i);
                    %>
                    <div class="item-find">
                        <%
                            String postId = String.valueOf(post.getPostID());
                            String encodedId = java.util.Base64.getEncoder().encodeToString(postId.getBytes());
                        %>
                        <div class="row">
                            <div class="col-md-5 pic">
                                <a href="./postDetail?id=<%=encodedId%>">
                                    <img src="data:image/png;base64,<%= inputStreamToBase64(post.getUrl()) %>" alt="" class="img-item">
                                </a>
                            </div>
                            <div class="col-md-7 des">
                                <h4 class="title">
                                    <a href="./postDetail?id=<%=encodedId%>"><%=post.getTitle()%></a>
                                </h4>
                                <div class="location">
                                    <p class="address">Address: <%=post.getAddress()%></p>
                                </div>
                                <div class="contact">
                                    <p class="price">Price: <%= formatCurrency(post.getPrice()) %></p>
                                </div>
                                <div class="post-date">
                                    <p>Post Date: <%= post.getDate() %></p>
                                </div>
                                <div class="button-group">
                                    <button class="btn btn-primary" onclick="updatePost(<%= post.getPostID() %>)">Update</button>
                                    <button class="btn btn-danger" onclick="deletePost(<%= post.getPostID() %>)">Delete</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% 
                            }
                        }
                    %>
                </div>

            </div>
                
            <div class="pagination-contain">
                <div style="background-color: #000000;" class="pagination">
                    <% if (currentPage > 1) { %>
                    <a href="yourpost?page=<%= currentPage - 1 %>" style="color: #fff;" class="pagination-btn">&laquo;</a> <!-- Nút lùi -->
                    <% } %>
                    <% for (int i = 1; i <= totalPages; i++) { %>
                    <% if (i == currentPage) { %>
                    <a href="#" style="color: #ffffff; background-color: #000000; pointer-events: none;" onclick="return false;"><%= i %></a> <!-- Trang hiện tại -->
                    <% } else { %>
                    <a href="yourpost?page=<%= i %>" style="color: #ffffff; background-color: #000000;" ><%= i %></a>
                    <% } %>
                    <% } %>
                    <% if (currentPage < totalPages) { %>
                    <a href="yourpost?page=<%= currentPage + 1 %>" style="color: #fff;" class="pagination-btn">&raquo;</a> <!-- Nút tiến -->
                    <% } %>
                </div>
            </div>

            <!-- ***** Page content End ***** -->
        </div>

        <!-- ***** Footer Start ***** -->
        <div class="footer">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="row">
                            <div class="col-lg-4 right-logo">
                                <a href="index.html"><img style="object-fit: contain;" src="assets/images/logo3.png" alt="" class="footer-logo" /></a>
                            </div>

                            <div class="col-lg-4 center-info">
                                <h2>Kết nối với chúng tôi</h2>
                                <ul>
                                    <li>Hotline: <a href="tel:0987654321">098.765.4321</a></li>

                                    <li>Email: <a href="mailto:group1@gmail.com" target="_blank">group1@gmail.com</a></li>
                                    <li class="social">
                                        <a href="https://www.facebook.com/" target="_blank">
                                            <i class="bi bi-facebook" style="color: #ffffff; font-size: 20px;" ></i>
                                        </a>
                                        <a href="https://www.youtube.com/" target="_blank">
                                            <i class="bi bi-youtube" style="color: #ffffff; font-size: 20px;"></i>
                                        </a>
                                        <a href="https://www.instagram.com" target="_blank">
                                            <i class="bi bi-instagram" style="color: #ffffff; font-size: 20px;"></i>
                                        </a>
                                    </li>
                                </ul>
                            </div>

                            <div class="col-lg-4 left-contact">
                                <p>Copyright © 2023 <a href="#">Group 1</a> Company. <br>All rights reserved.</p>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <!-- ***** Footer End ***** -->

        <!-- Scripts -->
        <!-- Bootstrap core JavaScript -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>

        <script src="./assets/js/isotope.js"></script>
        <script src="./assets/js/owl-carousel.js"></script>
        <script src="./assets/js/tabs.js"></script>
        <script src="./assets/js/popup.js"></script>
        <script src="./assets/js/custom.js"></script>
        <script src="./assets/js/rental.js"></script>
        <script src="./assets/js/toast.js"></script>

        <script>
            if ("${requestScope.updateStatus}" === "failure") {
                alert("Update fail!");
            <%
                request.setAttribute("deleteStatus", null);
            %>
            } else if ("${requestScope.updateStatus}" === "success") {
                alert("Update success fully!");
            <%
                request.setAttribute("deleteStatus", null);
            %>
            }

                var databaseData = <%= new Gson().toJson(postList) %>;
                $(document).ready(function () {
                    $('.dropdown').on('focusin mouseenter', function () {
                        $(this).addClass('show').find('.dropdown-menu').addClass('show');
                    }).on('focusout mouseleave', function () {
                        $(this).removeClass('show').find('.dropdown-menu').removeClass('show');
                    });
                });
        </script>

    </body>

</html>




