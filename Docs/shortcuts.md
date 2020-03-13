# shortcuts

#### $\LaTeX$ 插图模板
\usepackage{caption}
\usepackage{graphicx, subfig}

\begin{figure}[h]
	\centering
	\includegraphics[width=2.8in]{TODO}
	\caption{TODO}
	\label{TODO}
\end{figure}

#### $\LaTeX$ 代码模板
\usepackage{listings}
\usepackage{color}

\definecolor{dkgreen}{rgb}{0,0.6,0}
\definecolor{gray}{rgb}{0.5,0.5,0.5}
\definecolor{mauve}{rgb}{0.58,0,0.82}

\lstset{frame=tb,
  language=Python,
  aboveskip=3mm,
  belowskip=3mm,
  showstringspaces=false,
  columns=flexible,
  basicstyle={\small\ttfamily},
  numbers=none,
  numberstyle=\tiny\color{gray},
  keywordstyle=\color{blue},
  commentstyle=\color{dkgreen},
  stringstyle=\color{mauve},
  breaklines=true,
  breakatwhitespace=true,
  tabsize=3
}


\begin{lstlisting}
    TODO
\end{lstlisting}