package com.example;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;


public class Server {
    public static void main(String[] args) throws IOException{
        DataBase.loadUsersFromFile();
        Executor executor = Executors.newVirtualThreadPerTaskExecutor();
        try (ServerSocket serverSocket = new ServerSocket(8080);) {
            while (true) {
                Socket socket = serverSocket.accept();
                executor.execute(new ClientHandler(socket));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
