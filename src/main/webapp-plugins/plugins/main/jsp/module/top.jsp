<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">MSTR</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarCollapse">
      <ul class="navbar-nav me-auto mb-2 mb-md-0">
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="/MicroStrategy/main">Home</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="/MicroStrategy/servlet/mstrWeb?evt=3003&src=mstrWeb.3003&server=localhost&Port=8080&Project=MicroStrategy Tutorial">My Reports</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="/MicroStrategy/wizard">비정형분석</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="/prac_board/board.do">게시판</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#">환경설정</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#">도움말</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#">환경설정</a>
        </li>
        <li class="nav-item">
          <a class="nav-link disabled">로그아웃</a>
        </li>
      </ul>
      <form class="d-flex">
        <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
        <button class="btn btn-outline-success" type="submit">Search</button>
      </form>
    </div>
  </div>
</nav>