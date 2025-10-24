<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title></title>
	
	<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
</head>

<body>
	<!-- Popper.js -->
	<script src="https://unpkg.com/@popperjs/core@2"></script>
	
	<!-- Bootstrap 5.3.8 -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
	
	<!-- SweetAlert 2 -->
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.23.0/dist/sweetalert2.all.min.js"></script>
	
	<!-- Template JS -->
	<script src="/js/material-dashboard.js"></script>
	<script>
		Swal.fire({
		  text: "${ resultMsg }",
		  icon: "${ resultIcon }",
		  showCancelButton: false,
		  confirmButtonColor: "#191919",
		  confirmButtonText: "확인"
		}).then((result) => {
			const url = "${ resultUrl }"
			const popupClose = "${ popupClose }"
			
			if( popupClose != null && popupClose == "true") {
				window.close()
			} else {
				
		    if (url != null && url != "") {
			    location.href = url
		    } else {
		  	    history.back()
		    }
			}
			
		});
	</script>
</body>

</html>