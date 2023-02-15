<%@ page language="java" pageEncoding="ISO-8859-1"%>
<%@ page import="j2ee.inventarios.struts.*,j2ee.inventarios.objects.*,java.util.Date,j2ee.inventarios.util.*,java.util.ResourceBundle,org.apache.struts.Globals,java.util.Locale" buffer="none"  %>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>
  
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<tiles:insert name="plantillaStandar" definition="plantillaStandar">

	<tiles:put name="base">
		<html:base />
	</tiles:put>

  <tiles:put name="scripts" type="String">
    <script type="text/javascript" language="javascript">
	
	function changePassword(){
		window.location.replace('changePassword.jsp');
	}	
  function abrirVentana(direccion, w, h, x, y ){
		if(w==null)	w='430';
		if(h==null)	h='500';
		if(x==null)	x= (screen.width -w)/2;
		if(y==null)	y= (screen.height - h)/2 ;
    window.open(direccion,'_blank','scrollbars=yes,directories=no,resizable=yes,channelmode=no,titlebar=no,location=no,left='+x+',top='+y+', width='+w+', height='+h+'','false');
  }


function enviar(accion){
	      		var formulario= document.getElementById('formulario');
            var href = formulario.action;                        		
                    
            if(href.indexOf('?') >0 ){
              href= href.substring(0,href.indexOf('?'));
            }
            
            href+='?cmd='+accion;	
            formulario.action= href;
                          
            formulario.submit();					
	      	}
          
          function isEnter(e) {
            var pK = document.all? window.event.keyCode:e.which;
            var form = document.forms[0];
            if(pK == 13){
              enviar('Login');
              //form.cmd.value = "findAllRows";
              //form.submit();
            }
          }
		  
  
		  //onReady
        $(function(){
            $('#fondoLogeado').css('background','');
            $('#username').focus();
            $('#username').select();
			$("#containerS").css("width", 960);
        });
        		
		function ldvRol(){    
			var user = document.getElementById('idusuario').value;
			var ciacode = document.getElementById('ciacode').value;
			abrirVentana('ldvAction.do?xmlArchivo=RolXUsuario&sysid=157&user='+user+'&ciacode='+ciacode);
		}	
		  
    </script>
	
  <link href="style/cssinventario.css" rel="stylesheet" type="text/css">
  </tiles:put>

	<jsp:include page="LoginFramePage.jsp"  />

	<tiles:put name="title" type="String">
		<bean:message key="login.titulo" />
	</tiles:put>	
  
      <tiles:put name="encabezado" type="String">
		<bean:message key="login.encabezado" />
	</tiles:put>
  
	<tiles:put name="contenido" type="String">
		<html:form action="/Login.do" styleId="formulario" >						
			<center bgcolor="">
				<table class="tableLogin">
				<logic:notPresent name="logged">
					<tr>
						<th>
							<bean:message key="login.username" />
						</th>
						<td>
							<html:text property="idusuario" styleId="idusuario" value =""/>
							<html:messages id="message" property="errors.idusuario.required">
              <br><span class="error" > <bean:write name="message" filter="false" /></span>
            </html:messages>
        </td>
  </tr>
  <tr> 
    <th>
							<bean:message key="login.password" />
						</th>
						<td>
							<html:password property="password" onkeypress="isEnter(event);" value= "" />
							<html:messages id="message" property="errors.password.required">
					          <br><span class="error" > <bean:write name="message" filter="false" /> </span>
					        </html:messages>
						</td>
                    </tr>
                    <tr> 
                        <th>
							<bean:message key="login.Rol" />
						</th>
                        <td valign="middle"><div align="left">
                              <html:hidden property="idRol" styleId="idRol" />
                            <html:text readonly="true" property="rolName" styleId="rolName" size="29" styleClass="caja_texto" value= ""/>
                            <img align="middle" src="<%=request.getContextPath()%>/images/window-new.png" name="btntuso"
							onmouseover="this.className='formButtonHoverLv';this.style.cursor='pointer'" 
											onmouseout="this.className='formButtonLv';this.style.cursor='default'"
									border="0" onclick="ldvRol();"/>
							<html:messages id="message" property="errors.rol.required">
					          <br><span class="error" > <bean:write name="message" filter="false" /> </span>
					        </html:messages>
                        </div></td>
  </tr>
   <tr> 
						<th>
                        <bean:message key="login.lenguaje"/>
            </th>
            <td >
            <div align="left">
              <html:select property="lenguaje" styleId="lenguaje" onchange="javascript:enviar('change')" >
                <html:option value="1">
                  <bean:message key="lenguaje.ingles"/>
                </html:option>    
                <html:option value="2">
                  <bean:message key="lenguaje.espanol"/>
                </html:option>                            
              </html:select>
              </div>
            </td>
          </tr>
            </logic:notPresent>     
		<tr> <th>&nbsp;</th>
      <td>
            <html:hidden property="ciacode" styleId="ciacode" value="AESV"/>
            <html:hidden property="stationcode" styleId="stationcode" value="SAL"/>
            <html:hidden property="stationname" styleId="stationname" value="ESTACION AEROMAN EL SALVADOR"/>
            <html:hidden property="cianame" styleId="cianame" value="AEROMAN EL SALVADOR"/>
        </td>
		</tr>
</table>				
	   <br>
       <html:button  property="accion" styleId="ingresar" onclick="javascript:enviar('logUser');" 
	   styleClass="formButton" onmouseover="this.className='formButtonHover';this.style.cursor='pointer'" 
							   onmouseout="this.className='formButton';this.style.cursor='default'">
        <bean:message key="login.ingresar"/>
	   </html:button>
	   <br>
	   <html:messages id="message" property="login.fail.password">
        <br><span class="error" > <bean:write name="message" filter="false" /> </span>
	   </html:messages>
	   <html:messages id="message" property="login.fail.username">
       <br><span class="error" > <bean:write name="message" filter="false" /> </span>
	   </html:messages>

		<hr width="80%"  >
	</center>
  </html:form>
  <br>
  </tiles:put>
</tiles:insert>