import React from "react";
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import { Header } from "./Header"; 

export const AboutUs: React.FC = () => {
    return (         
        <div><Header />
            <div>This is the About Us screen for React demo developed by Prashant Akhouri</div>
            </div>
    ); 
}

export default AboutUs;