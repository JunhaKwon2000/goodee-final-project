<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<aside class="sidenav navbar navbar-vertical border-radius-lg ms-2 bg-white my-2 w-10 align-items-start" style="height: 92vh; width: 200px !important;">
	<div class="w-100">
		<ul class="navbar-nav">
			<li>
				<div class="d-flex">
					<ul class="navbar-nav" id="drive-my">
						<li class="nav-item d-flex align-items-center justify-content-between" style="min-width: 170px">
							<a class="nav-link text-dark w-100" href="/address">
								<i class="material-symbols-rounded opacity-5 fs-5" data-content="${ dept.deptDetail }">3p</i>
								<span class="nav-link-text ms-1 text-sm text-truncate" style="max-width: 110px;">&nbsp;전체</span>
							</a>
						</li>
					</ul>
				</div>
				
			<li>
				<hr class="my-1 bg-dark">
			</li>
				<div class="d-flex">
					<ul class="navbar-nav" id="drive-my">
						<c:if test="${ deptList ne null}">
						<c:forEach items="${ deptList }" var="dept">
							<li class="nav-item d-flex align-items-center justify-content-between" style="min-width: 170px">
								<a class="nav-link text-dark w-100" href="/address/${dept.deptCode}">
									<i class="material-symbols-rounded opacity-5 fs-5" data-content="${ dept.deptDetail }">3p</i>
									<span class="nav-link-text ms-1 text-sm text-truncate" style="max-width: 110px;">&nbsp;${ dept.deptDetail }</span>
								</a>
							</li>
						</c:forEach>
						</c:if>
					</ul>
				</div>
			</li>
		</ul>
	</div>
</aside>