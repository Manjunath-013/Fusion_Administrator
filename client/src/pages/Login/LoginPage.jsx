import React from "react";
import { useForm } from "@mantine/form";
import { TextInput, Button, Paper, Container, Title } from "@mantine/core";
import { useNavigate } from "react-router-dom";
import { handleLogin } from "../../services/authServices.jsx";
import { useAuth } from "../../context/AuthContext";
import axiosInstance from "../../context/axiosInstance.jsx";

const LoginPage = () => {
  const form = useForm({
    initialValues: { email: "", password: "" },
    validate: {
      email: (value) => (/^\S+@\S+$/.test(value) ? null : "Invalid email"),
      password: (value) => (value.length >= 6 ? null : "Password must be at least 6 characters"),
    },
  });

  const navigate = useNavigate();
  const { login } = useAuth();

  const onLogin = async (values) => {
    try {
      // Try Firebase login first (if configured)
      const firebaseUser = await handleLogin(values.email, values.password);
      
      // If Firebase is not configured, use simple backend authentication
      if (!firebaseUser) {
        console.log("Using backend authentication - skipping Firebase");
        // For now, just set authentication state without backend validation
        // You can manually add a token in localStorage if needed for API calls
        localStorage.setItem("authToken", "demo-token-for-testing");
        console.log("Logged in with backend (demo mode)");
        login();
        navigate("/UserDirectory", { replace: true });
      } else {
        // Firebase login succeeded
        console.log("Logged in user:", firebaseUser);
        login();
        navigate("/UserDirectory", { replace: true });
      }
    } catch (error) {
      console.error("Login error:", error.message);
      alert("Invalid credentials or login failed. Please try again");
    }
  };

  return (
    <Container size={420} my={40}>
      <Title align="center">Welcome back!</Title>
      <Paper withBorder shadow="md" p={30} mt={30} radius="md">
        <form onSubmit={form.onSubmit(onLogin)}>
          <TextInput label="Email" placeholder="Your Email" {...form.getInputProps("email")} required />
          <TextInput
            label="Password"
            placeholder="Your password"
            type="password"
            mt="md"
            {...form.getInputProps("password")}
            required
          />
          <Button type="submit" fullWidth mt="xl">
            Login
          </Button>
        </form>
      </Paper>
    </Container>
  );
};

export default LoginPage;
