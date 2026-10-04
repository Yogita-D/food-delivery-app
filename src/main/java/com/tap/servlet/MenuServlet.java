package com.tap.servlet;
import java.io.IOException;
import java.util.List;

import com.tap.DAOImpl.MenuDAOImpl;
import com.tap.model.Menu;
import com.tap.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        int restaurantId =
        Integer.parseInt(req.getParameter("restaurantId"));

        MenuDAOImpl menuDAOImpl = new MenuDAOImpl();

        List<Menu> allMenu = menuDAOImpl.getAllMenusByRestaurant(restaurantId);


		for (Menu menu : allMenu)
		{
			System.out.println(menu);
		}
		req.setAttribute("allMenu", allMenu);
		
		RequestDispatcher rd = req.getRequestDispatcher("Menu.jsp");
		rd.forward(req,  resp);
    }

}